import 'package:wandoo/features/den/domain/furniture.dart';

String spotName(Spot s) => switch (s) {
  Spot.wall => 'Wand',
  Spot.lamp => 'Licht',
  Spot.bed => 'Bett',
  Spot.plant => 'Pflanze',
  Spot.rug => 'Teppich',
  Spot.toy => 'Spielzeug',
};

String furnitureName(Furniture f) => switch (f) {
  Furniture.leafWreath => 'Blätterkranz',
  Furniture.shellGarland => 'Muschelkette',
  Furniture.starPicture => 'Sternenbild',
  Furniture.glowJar => 'Glühwürmchenglas',
  Furniture.mushroomLamp => 'Pilzlampe',
  Furniture.moonLamp => 'Mondlampe',
  Furniture.hayNest => 'Heunest',
  Furniture.shellBed => 'Muschelbett',
  Furniture.cloudBed => 'Wolkenbett',
  Furniture.flowerPot => 'Blumentopf',
  Furniture.fern => 'Farn',
  Furniture.waterLily => 'Seerosenschale',
  Furniture.flowerRug => 'Blumenteppich',
  Furniture.waveRug => 'Wellenteppich',
  Furniture.starRug => 'Sternenteppich',
  Furniture.ball => 'Wasserball',
  Furniture.spinningTop => 'Kreisel',
  Furniture.toyBoat => 'Spielzeugboot',
};
