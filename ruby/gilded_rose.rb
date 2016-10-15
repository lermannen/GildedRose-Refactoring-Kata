class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if sulfuras?(item)
      step_time(item)
      case item.name
      when "Aged Brie"
        handle_aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert"
        handle_backstage_pass(item)
      when /^Conjured.*/
        degrade_item(item, 2)
      else
        degrade_item(item)
      end
    end
  end

  def sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def step_time(item)
    item.sell_in -= 1
  end

  def handle_aged_brie(item)
    if sell_in_passed?(item)
      increase_quality(item, 2)
    else
      increase_quality(item)
    end
  end

  def increase_quality(item, amount = 1)
    item.quality += amount unless item.quality >= 50
  end

  def handle_backstage_pass(item)
    increase_quality_backstage(item)
    item.quality = 0 if sell_in_passed?(item)
  end

  def increase_quality_backstage(item)
    if item.sell_in < 6
      increase_quality(item, 3)
    elsif item.sell_in < 11
      increase_quality(item, 2)
    else
      increase_quality(item)
    end
  end

  def degrade_item(item, factor = 1)
    if sell_in_passed?(item)
      decrease_item_quality(item, 2 * factor)
    else
      decrease_item_quality(item, 1 * factor)
    end
  end

  def decrease_item_quality(item, amount = 1)
    item.quality -= amount if item.quality > 0
  end

  def sell_in_passed?(item)
    item.sell_in < 0
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
