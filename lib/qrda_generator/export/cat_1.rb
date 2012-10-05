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

      # Given a set of measures, find the data criteria/value set pairs that are unique across all of them
      # Returns an Array of Hashes. Hashes will have a two key/value pairs. One for the data criteria oid
      # and another for the value set oid
      def unique_data_criteria(measures)
        all_data_criteria = measures.map {|measure| measure.all_data_criteria}.flatten
        dc_oids_and_vs_oids = all_data_criteria.map do |data_criteria|
          data_criteria_oid = QRDATemplateHelper.template_id_by_definition_and_status(data_criteria.definition, 
                                                                            data_criteria.status,
                                                                            data_criteria.negation)
          value_set_oid = data_criteria.code_list_id
          {'data_criteria_oid' => data_criteria_oid, 'value_set_oid' => value_set_oid}
        end
        dc_oids_and_vs_oids.uniq
      end

      extend self
    end
  end
end