module QrdaGenerator
  module Export
    module Cat1
      include HealthDataStandards::Export::TemplateHelper

      def export(patient, measures, start_date, end_date)
        self.template_format = "cat1"
        render(:template => 'show', :locals => {:patient => patient, :measures => measures, 
                                                :start_date => start_date, :end_date => end_date})
      end

      extend self
    end
  end
end