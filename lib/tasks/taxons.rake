namespace :taxons do
  desc "TODO"
  task seed_taxons: :environment do
    taxons = Spree::Taxon.create!([
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Potteries",
      },
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Glasses",
      },
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Metals",
      },
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Fashion",
      },
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Gifts",
      },
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Home Decorations",
      },
      {
          taxonomy_id: 1,
          parent_id: 1,
          name: "Accessories",
      }
    ])

    gifts = Spree::Taxon.find_by(name: "Gifts")
    gifts_taxons = Spree::Taxon.create!([
      {
          parent_id: gifts.id,
          taxonomy_id: 1,
          name: "Daily Gifts",
      },
      {
          parent_id: gifts.id,
          taxonomy_id: 1,
          name: "Wedding Gifts",
      },
      {
          parent_id: gifts.id,
          taxonomy_id: 1,
          name: "Lover's Gifts",
      },
      {
          parent_id: gifts.id,
          taxonomy_id: 1,
          name: "Holiday Gifts",
      }
    ])

    fashion = Spree::Taxon.find_by(name: "Fashion")
    fashion_taxons = Spree::Taxon.create!([
      {
          parent_id: fashion.id,
          taxonomy_id: 1,
          name: "Bags",
      },
      {
          parent_id: fashion.id,
          taxonomy_id: 1,
          name: "Men",
      },
      {
          parent_id: fashion.id,
          taxonomy_id: 1,
          name: "Women",
      },
      {
          parent_id: fashion.id,
          taxonomy_id: 1,
          name: "Shoes",
      },
      {
          parent_id: fashion.id,
          taxonomy_id: 1,
          name: "Watches",
      }
    ])
    p "Created #{taxons.count + gifts_taxons.count + fashion_taxons.count} taxons"
  end

end
