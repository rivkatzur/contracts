module Contracts
  require_dependency 'time_entry'

  module TimeEntryPatch
    def self.included(base)
      base.class_eval do 
        unloadable
        belongs_to :contract
        safe_attributes 'contract_id'
        base.send(:include, InstanceMethods)
        after_save :alert_project_manager
      end
    end
    
    module InstanceMethods
      def alert_project_manager
        unless contract_id.nil?
          self.contract.alert_project_manager
        end
      end
    end
  end
  
  TimeEntry.send(:include, TimeEntryPatch)
end
