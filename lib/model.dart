class Welcome {
  List<Ability> abilities;
  int baseExperience;
  List<Species> forms;
  int height;
  int id;
  bool isDefault;
  String locationAreaEncounters;
  String name;
  int order;
  Species species;
  Sprites sprites;
  List<Stat> stats;
  List<Type> types;
  int weight;

  Welcome({
    required this.abilities,
    required this.baseExperience,
    required this.forms,
    required this.height,
    required this.id,
    required this.isDefault,
    required this.locationAreaEncounters,
    required this.name,
    required this.order,
    required this.species,
    required this.sprites,
    required this.stats,
    required this.types,
    required this.weight,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    return Welcome(
      abilities: List<Ability>.from(
        json["abilities"].map((x) => Ability.fromJson(x)),
      ),
      baseExperience: json["base_experience"],
      forms: List<Species>.from(json["forms"].map((x) => Species.fromJson(x))),
      height: json["height"],
      id: json["id"],
      isDefault: json["is_default"],
      locationAreaEncounters: json["location_area_encounters"],
      name: json["name"],
      order: json["order"],
      species: Species.fromJson(json["species"]),
      sprites: Sprites.fromJson(json["sprites"]),
      stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
      types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
      weight: json["weight"],
    );
  }
}

class Ability {
  Species ability;
  bool isHidden;
  int slot;

  Ability({required this.ability, required this.isHidden, required this.slot});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability: Species.fromJson(json["ability"]),
      isHidden: json["is_hidden"],
      slot: json["slot"],
    );
  }
}

class Species {
  String name;
  String url;

  Species({required this.name, required this.url});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(name: json["name"], url: json["url"]);
  }
}

class Sprites {
  String? frontDefault;

  Sprites({this.frontDefault});

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(frontDefault: json["front_default"]);
  }
}

class Stat {
  int baseStat;
  int effort;
  Species stat;

  Stat({required this.baseStat, required this.effort, required this.stat});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      baseStat: json["base_stat"],
      effort: json["effort"],
      stat: Species.fromJson(json["stat"]),
    );
  }
}

class Type {
  int slot;
  Species type;

  Type({required this.slot, required this.type});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(slot: json["slot"], type: Species.fromJson(json["type"]));
  }
}
