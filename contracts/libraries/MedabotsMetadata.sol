// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MedabotsMetadata {
  struct Metadata {
    uint8 nameId;
    Part partId;
    string imageUrl;
    uint8 speed;
    uint8 life;
    uint8 attack;
    uint8 defense;
    Rarity rarityId;
    Family familyId;
  }

  // enum Name {
  //     Mikazuki,
  //     Subotai,
  //     Necronmo,
  //     Sonikka,
  //     Leppux,
  //     Havoc,
  //     Sucubo,
  //     Gachala,
  //     Shinobi,
  //     Donnardo,
  //     Phalco,
  //     Olympus,
  //     Jetto,
  //     Geisha,
  //     Kabuto,
  //     Exyll,
  //     Sanctus,
  //     Antrox,
  //     Akakumo,
  //     Inferno,
  //     Octonaut,
  //     Qwerty,
  //     Tweezers,
  //     W4Sabi
  // }

  enum Part {
    Core,
    RightArm,
    LeftArm,
    Legs
  }

  enum Family {
    Human,
    Spider,
    Flying
  }

  enum Rarity {
    Common,
    Uncommon,
    Rare,
    Epic,
    Legendary
  }
}
