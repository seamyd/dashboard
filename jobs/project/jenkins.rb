class Project < Dashing::Job
  module Jenkins

    def jenkins_attributes(project)
      get_status_for(project)
    end

  private

    def get_status_for(project)
      json = get_json_for_job(project)
      return {} if json.empty?

      actions = parse_action(json)

      {
        trigger:  trigger(json),
        sha1:     (actions['lastBuiltRevision']['SHA1'] rescue nil),
        branch:   (actions['lastBuiltRevision']['branch'][0]['name'] rescue nil),
        github:   (actions['remoteUrls'][0].include?('github.com') rescue nil),
        building: json['building'],
        estimatedDuration: json['estimatedDuration'],
        result:   json['result'],
        latestResult: get_json_for_job(project, 'lastCompletedBuild')['result'],
        url:      json['url'],
        culprits: culprits(json)
      }
    end

    def api_url(project, build)
      api_url = 'http://%s/job/%s/%s/api/json?tree=%s'
      api_url = api_url % [ENV['JENKINS_HOST'], project, build, api_fields]
    end

    def api_fields
      'actions[
        causes[
          shortDescription,
          lastBuiltRevision[
            SHA1,
            branch[name]
          ]
        ],
        remoteUrls
      ],
      building,
      estimatedDuration,
      result,
      url,
      culprits[
        fullName
      ]
      '.gsub(/\s/,'')
    end

    def get_json_for_job(job_name, build = 'lastBuild')
      api_response = HTTParty.get(api_url(job_name, build), headers: { 'Accept' => 'application/json' } )
      JSON.parse(api_response.body)
    end

    def trigger(json)
      if json['actions'][0]['causes'][0]['shortDescription'].include?('timer')
        'timer'
      elsif json['actions'][0]['causes'][0]['shortDescription'].include?('SCM change')
        'scm'
      end
    end

    def culprits(json)
      committers = jenkins_config['committers']
      json['culprits'].each_with_object([]) do |culprit, array|
        array.push(committers[culprit['fullName']] || culprit['fullName'])
      end
    end

    def jenkins_config
      @jenkins_config ||= Psych.load_file(File.join(settings.root, 'config', 'jenkins.yml'))
    end

    def parse_action(json)
      if json['actions'] && (json['actions'][2] || json['actions'][3])
        json['actions'][2].any? ? json['actions'][2] : json['actions'][3]
      else
        nil
      end
    end
  end
end
