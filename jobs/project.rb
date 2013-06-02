Dir.glob("#{settings.root}/jobs/project/*", &method(:require))

class Project < Dashing::Job
  include Project::Jenkins

  def do_execute
  end

  def execute
    projects.each do |project|
      data = Hash.new
      data[:jenkins] = jenkins_attributes(project)

      send_event(project, data) if data
    end
  end

protected

  def projects
    Sinatra::Application.config[:dashboards].each_with_object([]) do |(_,d),a|
      a << d[:widgets].select do |widget|
        widget[:view] == 'Project'
      end.map{ |h| h[:event] }
    end.flatten
  end
end
