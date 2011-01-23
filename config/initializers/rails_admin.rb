RailsAdmin.config do |config|
  config.excluded_models << User
  config.model TwitUser do
    list do 
      field :screen_name do
        column_width 100
      end
      field :state do
        column_width 100
      end
      field :following do
        column_width 10
      end
      field :location do
        column_width 100
      end
      field :is_cheboksary do
        column_width 20
      end
      field :source do
        column_width 100
      end
      field :cheboksary_source do
        column_width 100
      end
      items_per_page 100
    end
  end
end
