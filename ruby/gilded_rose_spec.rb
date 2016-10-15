require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  let(:items) {
              [
               Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
               Item.new(name="Aged Brie", sell_in=2, quality=0),
               Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
               Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
               Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
               Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
               Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
               Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
               # This Conjured item does not work properly yet
               Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
              ]}

  describe "#update_quality" do
    # it "conforms to the normal spec" do
    #   days = 31
    #   result = "OMGHAI!\n"
    #   gilded_rose = GildedRose.new items
    #   (0...days).each do |day|
    #     result << "-------- day #{day} --------\n"
    #     result << "name, sellIn, quality\n"
    #     items.each do |item|
    #       result << item.to_s + "\n"
    #     end
    #     result <<  "\n"
    #     gilded_rose.update_quality
    #   end

    #   expected = IO.read("../texttests/ThirtyDays/stdout.gr")
    #   expect(result).to eq expected
    # end

    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "degrades the quality when a day passes" do
      items = [Item.new("sword", 1, 1)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 0
      expect(items[0].quality).to eq 0
    end

    it "when sell date is passed it degrades twice as fast" do
      items = [Item.new("sword", -1, 4)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq -2
      expect(items[0].quality).to eq 2
    end

    it "the quality of an item is never negative" do
      items = [Item.new("sword", 1, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 0
      expect(items[0].quality).to eq 0
    end

    it "Aged Brie actually increases in Quality the older it gets" do
      items = [Item.new("Aged Brie", 1, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 0
      expect(items[0].quality).to eq 1
    end

    it "The Quality of an item is never more than 50" do
      items = [Item.new("Aged Brie", 1, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 0
      expect(items[0].quality).to eq 50
    end

    it "Sulfuras, being a legendary item, never has to be sold or decreases in Quality" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 1, 80)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 1
      expect(items[0].quality).to eq 80
    end

    context "Backstage passes" do
      it "Quality increases by 1 when sell_in is larger than 10" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 11
        expect(items[0].quality).to eq 1
      end
      it "Quality increases by 2 when there are 10 days or less" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 2
      end
      it "Quality increases by 3 when there are 5 days or less" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 3
      end

      it "Quality drops to 0 after the concert" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 5)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq -2
        expect(items[0].quality).to eq 0
      end
    end

    it "Conjured items degrade in Quality twice as fast as normal items" do
      items = [Item.new("Conjured Mana Cake", 5, 4)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 4
        expect(items[0].quality).to eq 2
    end
  end
end
