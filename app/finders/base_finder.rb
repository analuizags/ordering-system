class BaseFinder
  attr_reader :init_collection, :params

  def initialize(params: {}, init_collection:)
    @init_collection = init_collection
    @params = initialize_params(params)
  end

  def execute
    init_collection
  end

  protected

    def initialize_params(raw_params)
      new_params = raw_params.delete_if { |_, value| value.blank? }
      HashWithIndifferentAccess.new(new_params)
    end
end
