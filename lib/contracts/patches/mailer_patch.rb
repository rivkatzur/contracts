
module Contracts
  require_dependency 'mailer'

  module MailerPatch
    def self.included(base)
      base.class_eval do 
        base.send(:include, InstanceMethods)
      end
    end

    module InstanceMethods
     
      def contract_exploited_hours(contract, percents)
        redmine_headers 'Project' => contract.project.identifier,
                        'Contract' => contract.title
        project = contract.project
        recipients = project.users.each{|user| user.roles_for_project(project).first[:permissions].include?(:notify_exploited_hours)}.map(&:mail)
        @contract = contract
        @percents = percents
        @contract_url = contract.contract_url || ""   
        mail(:to => recipients,  :subject => "[#{project.name} - #{contract.title}]") do |format|
          format.text
          format.html
        end 
        return true  
      end             
    end

  end
  Mailer.send(:include, MailerPatch)
end
