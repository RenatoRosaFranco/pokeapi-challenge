class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    case item
    when name?('Aged Brie') && !item.name?('')

    when name?('Sulfuras, Hand of Ragnaros')
    
    when sell_in < 0
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    [@name, @sell_in, @quality].join(', ')
  end

  def name?(name)
    @name.eq?(name)
  end
end