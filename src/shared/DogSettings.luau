local DogSettings = {}

DogSettings.Dogs = {
    -- 普通犬 (用Dog币购买)
    ["Labrador"] = { Rarity = "Common", Price = 500, Currency = "DogCoins" },
    ["Beagle"] = { Rarity = "Common", Price = 600, Currency = "DogCoins" },
    ["Poodle"] = { Rarity = "Common", Price = 700, Currency = "DogCoins" },
    ["Chihuahua"] = { Rarity = "Common", Price = 400, Currency = "DogCoins" },
    ["Corgi"] = { Rarity = "Common", Price = 800, Currency = "DogCoins" },
    ["Dalmatian"] = { Rarity = "Common", Price = 900, Currency = "DogCoins" },

    -- 稀有犬 (用Dog币购买)
    ["ShibaInu"] = { Rarity = "Rare", Price = 2500, Currency = "DogCoins" },
    ["GoldenRetriever"] = { Rarity = "Rare", Price = 3000, Currency = "DogCoins" },
    ["Husky"] = { Rarity = "Rare", Price = 3200, Currency = "DogCoins" },
    ["GermanShepherd"] = { Rarity = "Rare", Price = 3500, Currency = "DogCoins" },

    -- 超稀有犬 (用Dog币购买)
    ["Doberman"] = { Rarity = "SuperRare", Price = 10000, Currency = "DogCoins" },
    ["GreatDane"] = { Rarity = "SuperRare", Price = 12000, Currency = "DogCoins" },

    -- 限量版 (用Robux购买)
    ["RoboDog"] = { Rarity = "Limited", Price = 100, Currency = "Robux", ProductId = 0000001 },
    ["GhostDog"] = { Rarity = "Limited", Price = 250, Currency = "Robux", ProductId = 0000002 },
}

return DogSettings
