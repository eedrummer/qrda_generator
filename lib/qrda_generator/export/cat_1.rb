module QrdaGenerator
  module Export
    module Cat1
      include HealthDataStandards::Export::TemplateHelper

      def export(patient, measures)
        self.template_format = "cat1"
        render(:template => 'show', :locals => {:patient => patient, :measures => measures})
      end

      extend self
    end
  end
end