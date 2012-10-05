module QrdaGenerator
  module Export
    module Cat1
      include HealthDataStandards::Export::TemplateHelper
      include HealthDataStandards::Util

      def export(patient, measures, start_date, end_date)
        self.template_format = "cat1"
        render(:template => 'show', :locals => {:patient => patient, :measures => measures, 
                                                :start_date => start_date, :end_date => end_date})
      end

      # Find all of the entries on a patient that match the given data criteria
      def entries_for_data_criteria(data_criteria, patient)
        data_criteria_oid = QRDATemplateHelper.template_id_by_definition_and_status(data_criteria.definition, 
                                                                                    data_criteria.status,
                                                                                    data_criteria.negation)
        entries = patient.entries_for_oid(data_criteria_oid)
        codes = ValueSetManager.codes_for_oid(data_criteria.code_list_id)
        entries.find_all { |entry| entry.is_in_code_set?(codes) }
      end

      # Given a set of measures, find the data criteria that are unique across all of them
      def unique_data_criteria(measures)
        all_data_criteria = measures.inject([]) {|memo, measure| memo + measures.all_data_criteria}
      end

      extend self
    end
  end
end