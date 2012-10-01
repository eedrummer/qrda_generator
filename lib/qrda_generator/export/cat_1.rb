module QrdaGenerator
  module Export
    module Cat1
      include HealthDataStandards::Export::TemplateHelper

      def export(patient)
        self.template_format = "cat1"
        render(:template => 'show', :locals => {:patient => patient})
      end

      extend self
    end
  end
end