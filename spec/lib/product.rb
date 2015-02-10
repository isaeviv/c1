class Product < C1::StandardOdata::Entry
  self.resource_id = 'Catalog_Товары'

  PROPS = ['Description', 'Описание']
end