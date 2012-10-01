module QrdaGenerator
  module Export
    module Cat1
      include HealthDataStandards::Export::TemplateHelper

      # Hack to override the template_root in Health Data Standards,
      # which will only reference templates in the Health Data Standard
      # gem
      def template_root
        File.join(File.dirname(__FILE__), '..', '..', '..', 'templates')
      end

      def export(patient)
        self.template_format = "cat1"
        render(:template => 'show', :locals => {:patient => patient})
      end

      extend self
    end
  end
end