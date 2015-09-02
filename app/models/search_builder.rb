class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Hydra::AccessControlsEnforcement
  include Sufia::SearchBuilder

  # overidden from gems/blacklight-5.14.0/lib/blacklight/solr/search_builder_behavior.rb
  # to turn arrays of values into a list of OR terms.
  def add_facet_fq_to_solr(solr_parameters)
    # convert a String value into an Array
    if solr_parameters[:fq].is_a? String
      solr_parameters[:fq] = [solr_parameters[:fq]]
    end

    # :fq, map from :f.
    if (blacklight_params[:f])
      f_request_params = blacklight_params[:f]

      f_request_params.each_pair do |facet_field, value_list|
        next if value_list.blank?
        solr_parameters.append_filter_query search_term(facet_field, value_list)
      end
    end
  end

  def search_term(field, value)
    case value
    when Array
      array_search_term(field, value)
    else
      single_search_term(field, value)
    end
  end

  def array_search_term(field, value_list)
    value_list
      .reject(&:blank?)
      .map { |value| %Q[#{field}:"#{value}"] }
      .join(conjuction(field))
  end

  def single_search_term(field, value)
    facet_value_to_fq_string(field, value)
  end

  def conjuction(field)
    field[0] == "!" ? " AND " : " OR "
  end
end
