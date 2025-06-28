import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicDetailPage extends StatelessWidget {
  final String topicTitle;
  final String topicContent;

  const TopicDetailPage({
    super.key,
    required this.topicTitle,
    required this.topicContent,
    // No changes to parameters
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          topicTitle,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:const Color.fromARGB(255, 1, 39, 2), 
        elevation: 0,
      ),
      body: Stack(
        // Use Stack to layer the background image and content
        children: [
          // 1. Background Image Layer
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin_img.png'),
                  fit: BoxFit.cover, 
                ),
              ),
            ),
          ),
         
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      topicContent,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// --- End of TopicDetailPage Placeholder ---


// --- Climate Education Page ---
class ClimateEducationPage extends StatelessWidget {
   ClimateEducationPage({super.key});

  
 final List<Map<String, dynamic>> educationTopics = const [
  {
    "title": "The Greenhouse Effect",
    "icon": Icons.eco_outlined,
    "content":
        "The greenhouse effect is a fundamental natural process vital for sustaining life on Earth. It works by trapping some of the Sun's energy within our atmosphere. When sunlight reaches Earth, about 30% is reflected back into space by clouds, ice, and other reflective surfaces. The remaining 70% is absorbed by the land and oceans, warming the planet. As the Earth warms, it emits heat back into the atmosphere in the form of infrared radiation. Certain gases in the atmosphere, known as greenhouse gases (GHGs), absorb this outgoing infrared radiation. These gases include carbon dioxide (CO2), methane (CH4), nitrous oxide (N2O), and water vapor (H2O). Instead of letting all the heat escape into space, these GHGs re-emit some of it back towards Earth's surface, effectively warming the lower atmosphere and the planet. Without the natural greenhouse effect, Earth's average temperature would be around -18°C (0°F), making it uninhabitable for most life forms. \n\nHowever, human activities since the Industrial Revolution have significantly increased the concentration of these greenhouse gases in the atmosphere. The burning of fossil fuels (coal, oil, natural gas) for energy, deforestation, industrial processes, and certain agricultural practices release massive amounts of CO2, methane, and other GHGs. This rapid increase in GHG concentrations enhances the natural greenhouse effect, leading to an accelerated warming of the planet, commonly known as global warming or climate change. The consequences of this enhanced effect are far-reaching, including rising global temperatures, more frequent and intense heatwaves, changes in precipitation patterns, melting glaciers and ice caps, sea-level rise, and increased frequency of extreme weather events. Understanding this process is the first step towards recognizing the urgency of reducing our emissions."
  },
  {
    "title": "Renewable Energy",
    "icon": Icons.lightbulb_outline,
    "content":
        "Renewable energy sources are derived from natural processes that are continuously replenished. Unlike fossil fuels, which are finite and release greenhouse gases when burned, renewables offer a sustainable path to power our world without depleting resources or exacerbating climate change. \n\nSolar Power: Harnesses sunlight using photovoltaic (PV) panels or concentrated solar power (CSP) systems to generate electricity or heat. It's abundant and can be deployed from large-scale power plants to rooftop installations.\n\nWind Power: Utilizes wind turbines to convert wind's kinetic energy into electricity. Modern turbines are highly efficient and can be located on land (onshore) or at sea (offshore), with offshore wind offering significant potential due to stronger, more consistent winds.\n\nHydropower: Generates electricity by harnessing the energy of moving water, typically through dams that create reservoirs. It's a mature technology that provides reliable baseload power, though it can have environmental impacts on aquatic ecosystems.\n\nGeothermal Energy: Taps into the Earth's internal heat. Geothermal power plants use steam from reservoirs deep underground to drive turbines, while geothermal heat pumps can be used for heating and cooling buildings directly.\n\nBiomass Energy: Comes from organic materials like agricultural waste, wood, and dedicated energy crops. It can be burned directly, converted into biofuels (ethanol, biodiesel), or used in anaerobic digesters to produce biogas. While renewable, its sustainability depends heavily on responsible sourcing and management.\n\nOcean Energy: An emerging category that includes wave power, tidal power, and ocean thermal energy conversion (OTEC), all utilizing the kinetic or thermal energy of the oceans. \n\nThe global shift towards these renewable energy sources is paramount for reducing carbon emissions, enhancing energy security, and fostering a sustainable economy. Investments in R&D and supportive policies are accelerating their deployment worldwide."
  },
  {
    "title": "Carbon Footprint",
    "icon": Icons.gas_meter,
    "content":
        "Your carbon footprint represents the total amount of greenhouse gases (GHGs) – primarily carbon dioxide (CO2), but also methane (CH4), nitrous oxide (N2O), and fluorinated gases – that are generated by your daily activities. It's a measure of the impact human activities have on the environment in terms of the amount of GHGs produced, expressed as tons of carbon dioxide equivalent (tCO2e).\n\nAlmost every action we take contributes to our carbon footprint, directly or indirectly:\nTransportation: Driving gasoline cars, flying, or even public transport powered by fossil fuels.\nEnergy Consumption: Electricity used in homes and offices (especially if generated from coal or natural gas), heating, and cooling.\nDiet: The production, processing, transport, and disposal of food, particularly high-meat diets which are resource-intensive.\nConsumption of Goods: Manufacturing, transporting, and disposing of clothes, electronics, furniture, and other products.\nWaste: Landfilling organic waste produces methane, a potent GHG.\n\nUnderstanding your carbon footprint is the first step towards reducing it. This involves assessing your current lifestyle choices and identifying areas where emissions can be cut. Strategies for reduction include:\nSwitching to renewable energy providers or installing solar panels.\nUsing public transportation, cycling, walking, or electric vehicles.\nAdopting a more plant-based diet and reducing food waste.\nBuying fewer new goods, choosing sustainably produced items, and recycling.\nImproving home energy efficiency through insulation and efficient appliances.\n\nMany online calculators can help you estimate your personal carbon footprint, providing a valuable starting point for taking concrete steps towards a more sustainable and low-carbon lifestyle. Reducing individual footprints, when scaled up across populations, contributes significantly to global climate action."
  },
  {
    "title": "Climate Adaptation",
    "icon": Icons.landscape,
    "content":
        "Climate adaptation refers to the process of adjusting to the current or expected effects of climate change. It involves making changes in our systems and behaviors to reduce harm or take advantage of new opportunities arising from a changing climate. Since some level of global warming and its impacts are already unavoidable due to past emissions, adaptation is a critical necessity alongside mitigation efforts.\n\nAdaptation strategies can be diverse and implemented at various scales:\nInfrastructure: Building sea walls, storm surge barriers, or relocating infrastructure away from vulnerable coastal areas to protect against rising sea levels and storm events. Upgrading drainage systems to cope with heavier rainfall.\nWater Management: Developing drought-resistant crops, implementing water conservation programs, improving irrigation efficiency, and enhancing rainwater harvesting systems in regions facing water scarcity.\nAgriculture: Shifting planting times, introducing new crop varieties better suited to altered climate conditions, and developing more resilient farming practices.\nEcosystems: Protecting and restoring natural ecosystems like mangroves, coral reefs, and forests, which act as natural buffers against climate impacts (e.g., coastal protection from storms).\nHealth: Strengthening public health systems to deal with increased heat-related illnesses, vector-borne diseases (like malaria, dengue), and food/water insecurity.\nEarly Warning Systems: Enhancing meteorological services and communication systems to provide timely warnings for extreme weather events (e.g., floods, heatwaves, hurricanes), allowing communities to prepare and evacuate.\nUrban Planning: Designing 'cool' cities with more green spaces, reflective surfaces, and sustainable urban drainage systems to combat urban heat island effects and flood risks.\n\nAdaptation measures are often localized and context-specific, depending on the unique vulnerabilities and impacts faced by a region or community. Effective adaptation requires collaboration between governments, communities, scientists, and businesses to build resilience and ensure human well-being in a changing climate."
  },
  {
    "title": "Climate Mitigation",
    "icon": Icons.nature,
    "content":
        "Climate mitigation encompasses actions taken to reduce or prevent the emission of greenhouse gases (GHGs) into the atmosphere, or to enhance their absorption by carbon sinks. The primary goal of mitigation is to lessen the severity of global warming and its long-term impacts by stabilizing or reducing the concentration of GHGs in the atmosphere. Mitigation efforts are crucial because they address the root cause of climate change.\n\nKey strategies for climate mitigation include:\nTransition to Renewable Energy: Shifting from fossil fuels (coal, oil, natural gas) to clean energy sources like solar, wind, hydro, geothermal, and nuclear power for electricity generation, transportation, and industrial processes. This is the single most important mitigation strategy.\nEnergy Efficiency and Conservation: Reducing energy demand through improved insulation in buildings, more efficient appliances, smart grids, and behavioral changes. Using less energy means fewer emissions, regardless of the source.\nSustainable Transportation: Promoting public transport, cycling, walking, and the adoption of electric vehicles. Developing sustainable aviation fuels and shipping methods.\nSustainable Land Use and Forestry: Protecting and restoring forests (which absorb CO2), implementing sustainable agriculture practices that reduce emissions from fertilizer use and livestock, and preventing deforestation.\nCarbon Capture, Utilization, and and Storage (CCUS): Technologies that capture CO2 emissions from industrial sources or directly from the air, and then store or reuse them. While promising, these technologies are still developing and require significant investment.\nWaste Management: Reducing waste generation, increasing recycling and composting, and capturing methane emissions from landfills.\nIndustrial Process Improvements: Developing new industrial processes that are less carbon-intensive and improving the efficiency of existing ones.\n\nMitigation requires systemic changes across all sectors of the economy and society, from individual choices to international policy frameworks. International agreements like the Paris Agreement set targets for countries to reduce their emissions, highlighting the global collaborative effort needed for effective climate mitigation."
  },
  {
    "title": "Sustainable Living",
    "icon": Icons.eco,
    "content":
        "Sustainable living is a lifestyle approach that aims to reduce an individual's or society's negative impact on the environment, promote ecological balance, and ensure resources are available for future generations. It's about making conscious choices to minimize our ecological footprint and maximize social and economic well-being.\n\nThe core principles of sustainable living often revolve around:\nReducing Consumption: Buying less, choosing durable products, avoiding single-use items, and prioritizing needs over wants.\nReusing and Repairing: Extending the life cycle of products by reusing items and repairing rather than replacing them.\nRecycling and Composting: Properly disposing of waste so materials can be reprocessed or returned to nature.\nConserving Resources: Mindful use of water, electricity, and other natural resources in daily life.\nSupporting Local and Ethical: Choosing locally sourced goods and services, and supporting businesses with ethical and sustainable practices.\nMindful Transportation: Opting for walking, cycling, public transport, or electric vehicles instead of relying solely on fossil fuel-powered cars.\nSustainable Diet: Emphasizing plant-rich foods, reducing meat consumption (especially red meat), choosing seasonal and local produce, and minimizing food waste.\nEnergy Efficiency in the Home: Insulating homes, using energy-efficient appliances, and potentially switching to renewable energy sources for electricity.\nEducating Others: Sharing knowledge and inspiring others to adopt more sustainable practices.\n\nSustainable living is a continuous journey of learning and adapting, moving towards a lifestyle that respects planetary boundaries and promotes long-term resilience and well-being for all."
  },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Climate Education",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
         iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:const Color.fromARGB(255, 1, 39, 2), 
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin_img.png'),
                  fit: BoxFit.cover,
                ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: educationTopics.length,
          itemBuilder: (context, index) {
            final topic = educationTopics[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicDetailPage(
                      topicTitle: topic["title"],
                      topicContent: topic["content"],
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 6,
                color: Colors.white, 
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        topic["icon"],
                        size: 50,
                        color: const Color.fromARGB(255, 1, 89, 46), 
                      ),
                      const SizedBox(height: 12),
                      Text(
                        topic["title"],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 1, 39, 2), 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}