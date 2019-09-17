import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/backend/game.dart';
import 'package:freedm_grid_game/backend/events.dart';
import 'package:freedm_grid_game/backend/generator.dart';
import 'package:freedm_grid_game/backend/power.dart';

void initEvents(Game game) {
  game.registerEvent(1900, new Event(eventType.generator, "Gerald Gentleman Station available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
                "Gerald Gentleman Station",
                "assets/mro/generators/ggs_highres.jpg",
                "Gerald Gentleman Station is Nebraska’s largest electric generating facility, supplying enough electricity to serve 600,000 Nebraskans. It is consistently ranked as one of the lowest production-cost electric generation plants in the nation. ",
                1050,
                generatorType.coal,
                Power(665, 1365),
                0.5, -0.5, -0.08,
                false,
            )
        );
      })
  );

  game.registerEvent(1900, new Event(eventType.generator, "Cooper Nuclear Station available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
                "Cooper Nuclear Station",
                "assets/mro/generators/cooper.jpg",
                "Cooper Nuclear Station (CNS) operates as the largest, single-unit electrical generator in the state, generating 820 megawatts of electricity. This would be enough power to supply more than 310,000 residential customers during the hottest summer.",
                5000,
                generatorType.nuclear,
                Power(2000, 3750),
                0.1, 0.98, 0.06,
                false,
            )
        );
      })
  );

  game.registerEvent(1900, new Event(eventType.generator, "Sheldon Station available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
                "Sheldon Station",
                "assets/mro/generators/sheldon.jpg",
                "Sheldon Station generates 225 megawatts of electricity. Power generated here is distributed to Nebraska’s residents through transmission lines leading to Lincoln, Hastings and Beatrice. \n\n Bazinga.",
                1250,
                generatorType.coal,
                Power(695, 1165),
                0.5, 0.5, -0.05,
                false,
            )
        );
      })
  );

  game.registerEvent(1900, new Event(eventType.generator, "Springview II available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
              "Springview II",
              "assets/mro/generators/ainsworth.jpg",
              "Nebraska Public Power District constructed Nebraska’s first wind-energy generation facility in 1998 west of Springview. Wind energy supplements baseload generation and is an important part of Nebraska's diverse generation mix.",
              750,
              generatorType.wind,
              Power(305, 686),
              0.0, -0.25, -0.435,
              false,
            )
        );
      })
  );

  game.registerEvent(1900, new Event(eventType.generator, "Beatrice Power Station available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
              "Beatrice Power Station",
              "assets/mro/generators/beatrice.jpg",
              "NPPD’s gas and oil generation facilities add fuel diversity to our generation resource mix. While not utilized every day, the availability of these facilities protects our Nebraska customers from the expense associated with costly replacement power during times of high energy use or in the event one of our other baseload plants is offline.",
              1550,
              generatorType.gas,
              Power(850, 1465),
              0.3, 0.5, 0.1,
              false,
            )
        );
      })
  );

  game.registerEvent(1900, new Event(eventType.generator, "Elkhorn Ridge available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
              "Elkhorn Ridge",
              "assets/mro/generators/ainsworth.jpg",
              "Nebraska Public Power District constructed Nebraska’s first wind-energy generation facility in 1998 west of Springview. Wind energy supplements baseload generation and is an important part of Nebraska's diverse generation mix.",
              820,
              generatorType.wind,
              Power(375, 626),
              0.0, 0.7, -0.35,
              false,
            )
        );
      })
  );

  game.registerEvent(1900, new Event(eventType.generator, "Kingsley Hydro available",
          () {
        game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).add(
            Generator(
              "Kingsley Hydro",
              "assets/mro/generators/platte.png",
              "NPPD own and operates two hydroelectric generating facilities — at North Platte and Kearney on the Platte River and purchase 100 percent of the energy output from facilities owned by Central Nebraska Public Power and Irrigation District and Loup Public Power District. At each plant, water passes through turbines, generates electricity and continues on unchanged. The generators, totaling 28 megawatts, can serve 9,500 homes.",
              950,
              generatorType.hydro,
              Power(430, 1070),
              0.0, -0.88, -0.26,
              false,
            )
        );
      })
  );
}