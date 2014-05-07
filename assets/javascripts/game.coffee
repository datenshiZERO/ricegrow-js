(($, _) ->
  $ ->
    gameFsm = new machina.Fsm(
      initialState: "startGame"
      WEEDING_EFFECTS:   #lookup table for yield, hours, and cost for weeding methods
        "0": [0.75, 0, 0],
        "1": [1.00, 86, 0],
        "2": [1.05, 60, 0],
        "3": [1.15, 8, 95],
        "11": [1.15, 144, 0],
        "12": [1.15, 146, 0],
        "13": [1.20, 83, 95],
        "21": [1.15, 165, 0],
        "22": [1.15, 125, 0],
        "23": [1.20, 125, 95],
        "31": [1.20, 83, 95],
        "32": [1.20, 83, 95],
        "33": [1.25, 16, 180]
      VALID_WEEDING: ->
        _.keys(@WEEDING_EFFECTS).join ","
      SEEDBED_PREP_HOURS: 24 # 4 days x 6 hours/day for seedbed preparation
      TRACTOR_HOURS: 3       # Hours for tractor use in land preparation/ ha
      CARABAO_HOURS: 72      # Hours for carabao use in land preparation/ ha
                             # a carabao works a six hour day
      TRACTOR_RATE: 45       # Standard hourly rate for tractor and driver '98
      CARABAO_RATE: 25       # Standard hourly rate for carabao and driver '98
      FMT: "%-31s     %9.2f"
      FMT2: "    %-31s %9.2f"
      data:
        runCount: 1
        costs:
          irrigation: 945 # Irrigation fees '98
          landTax: 1015   # Land tax '98
        hours:
          transplanting: 18 * 8   # 18 person days for transplanting
        snailAttacks: 0
        fertNContent: ->
          0.45 * @fertApplRate
        seedYield: ->
          if @seedType is "LOCAL" then 1920 else 2250
        ureaFactor1: ->
          if @seedType is "LOCAL" then -2.6e-4 else -1.5e-4
        ureaFactor2: ->
          if @seedType is "LOCAL" then 0.023 else 0.032

      totalCosts: (key) ->
        @data.costs[key] ?= 0
        return @data.costs[key] * @data["farmSize"]
      labor: (key) ->
        @data.hours[key] ?= 0
        return (@data["farmSize"] * @data["wages"] / 8) * @data.hours[key]

      states:
        startGame:
          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              @data["skipIntro"] = response
              if response
                @transition "mainIntro"
              else
                @transition "intro1"
            return

        intro1:
          _onEnter: ->
            @message = """
            
            
            Welcome to the real world!  YOU ARE TO PLAY THE ROLE OF A
               SMALL-TIME RICE FARMER IN THE PHILIPPINES.  YOU HAVE
               CONTROL OVER MOST OF THE FACTORS WHICH INFLUENCE YOUR
               OUTPUT.  THE IDEA IS TO RAISE SEVERAL SUCCESSIVE CROPS,
               ALWAYS TRYING TO INCREASE YOUR RETURNS TO LABOR AND
               CAPITAL. A FAILURE FOR A SINGLE YEAR MAY MEAN A MAJOR
               CRISIS FOR YOU AND FOR THE FAMILY.  GOOD LUCK!!!
            
            
            
            YOU ARE A NEW OWNER AS A RESULT OF LAND REFORM.
            YOUR LAND IS IRRIGATED.
            YOUR HEADMAN WOULD LIKE YOU TO RAISE 'IR64' WHICH IS SAID TO
            ACHIEVE VERY HIGH YIELDS, BUT YOU ARE FAMILIAR WITH 'LOCAL' RICE
            AND HESITATE TO EXPERIMENT WITH NEW KINDS OF SEEDS.
            #{@waitText}
            """
            return

          input: (line) ->
            @transition "intro2"
            return

        intro2:
          _onEnter: ->
            @message = """
              
              
              
                  FIRST, A FEW TERMS YOU SHOULD KNOW:
                    HECTARE (HA.) = 10,000 SQ. METERS (2.47 ACRES)
                    KILOGRAM (KG.) = 2.2 POUNDS
                    PESO = U.S. $0.023 ($1 = 44 PESOS)
                    CAVAN = VOLUME MEASURE - ROUGHLY 50 KG. OF PALAY
                    PALAY = THE TERM FOR THRESHED BUT UNHUSKED RICE
                    IR64 = A HIGH YIELDING RICE VARIETY FIRST RELEASED IN 1985
                    LODGING = PLANT FALLS OVER FROM TOO WEAK STEM.
              #{@waitText}
              """
            return

          input: (line) ->
            @transition "factors1"
            return

        factors1:
          _onEnter: ->
            @message = """
              
              
              Factors you can control include (among others) the following 10:
              
                   1. SIZE OF FARM (IN HECTARES).
                THE MEAN FARM SIZE IN CENTRAL LUZON IS ABOUT 1.8 HA. BUT
                SOME FARMS ARE A FRACTION OF A HA. WHILE OTHERS ARE AS
                LARGE AS 50 HECTARES.
                
                   2. COSTS OF OUTSIDE LABOR (IN PESOS/DAY).
                LABOR COSTS PER DAY FOR FARM WORK (1998) VARY FROM PESOS
                105 TO PESOS 125 DEPENDING ON LOCATION AND SEASON. SOME
                SMALL SNACK FOODS ARE NORMALLY ADDED TO THIS COST.
                
                   3. TYPE OF RICE (SEED) USED.
                IR64 HAS GREAT POTENTIAL, BUT MOST FARMERS ARE FAMILIAR
                WITH LOCAL VARIETIES.
                #{@waitText}
              """
            return

          input: (line) ->
            @transition "factors2"
            return

        factors2:
          _onEnter: ->
            @message = """

                   4. COST OF SEED.
                SEEDS ARE USED AT THE RATE OF 1 CAVAN PER HA. OF FARM.
                ORDINARY HYV SEED COSTS 570 - 630 PESOS PER CAVAN.
                GOVERNMENT INSPECTED SEED OF VERY GOOD QUALITY SELLS AT 
                ABOUT 675 PESOS. SOMETIMES A FARMER WITH SURPLUS RICE
                WILL OFFER A 'DEAL' - SEED FOR much LOWER COST. SOME
                SHARP BUSINESS TYPES MAY OFFER 'SELECTED' SEED FOR AS
                MUCH AS 700 - 750 PESOS.

                LET'S ASSUME THAT OUR FARMER USES A VERY EFFICIENT SEED
                RATE OF ONE CAVAN PER HECTARE!
              #{@waitText}
              """
            return

          input: (line) ->
            @transition "factors3"
            return

        factors3:
          _onEnter: ->
            @message = """

                   5. USE OF SYSTEMIC PESTICIDE, I.P.M., OR NOTHING.
                I.P.M. (OR INTEGRATED PEST MANAGEMENT) INVOLVES CAREFUL
                CULTIVATION TECHNIQUES, THE ENCOURAGEMENT OF RICE PEST PREDATORS,
                AND CONSTANT MONITORING OF PEST INFESTATIONS. IF THESE EXCEED
                ACCEPTABLE LEVELS THEN A LIMITED SPRAY PROGRAM IS UNDERTAKEN.
                  SYSTEMIC PESTICIDES ARE DESIGNED TO RID YOUR FIELDS OF
                INSECTS. THIS OFTEN INCLUDES PEST PREDATORS AS WELL AS STEM-
                BORERS, ARMY WORMS AND LEAF HOPPERS.
                  SYSTEMICS ARE APPLIED AT TRANSPLANTING. (THIS IS WELL BEFORE
                ANY INSECT ATTACK WILL BE OBSERVED). SYSTEMICS ARE COSTLY
                BUT EFFECTIVE IN CUTTING LOSS FROM MANY INSECTS. MOST
                FARMERS GAMBLE ON A LIGHT ATTACK AND DON'T USE SYSTEMICS.
              #{@waitText}
              """
            return

          input: (line) ->
            @transition "factors4"
            return

        factors4:
          _onEnter: ->
            @message = """

                   6. COST AND AMOUNT OF NITROGEN FERTILIZER.
                UREA IS THE CHEAPEST FORM OF NITROGEN. BY WEIGHT IT HAS
                45 PERCENT N. A BAG OF UREA WEIGHS 50 KG.; AND COSTS BETWEEN
                PESOS 350 - 370 (1998).

                   7. METHOD OF CROPLAND PREPARATION.
                USE OF THE CARABAO IS TRADITIONAL, BUT MANY FARMERS TODAY
                ARE HAVING THEIR FIELDS CUSTOM PLOWED BY SMALL TRACTOR.
                ADVANTAGES OF THIS ARE SPEED AND BETTER WEED CONTROL.

                   8. METHOD OF WEEDING AND HERBICIDE APPLICATIONS.
                WEEDING TOO HAS TRADITIONALLY BEEN DONE BY HAND.
                THE USE OF HERBICIDES IS A RECENT INNOVATION.
              #{@waitText}
              """
            return

          input: (line) ->
            @transition "factors5"
            return

        factors5:
          _onEnter: ->
            @message = """

                   9. METHOD OF THRESHING.
                WITH INCREASED YIELDS MANY FARMERS ARE HIRING CUSTOM MACHINE
                THRESHING RATHER THAN STICKING WITH THE OLD HAND METHOD.

                   10. MARKET VALUE OF ROUGH RICE.
                VARIES WITH VARIETY, QUALITY AND SEASON. AVERAGES (1994)
                ABOUT 312 PESOS PER CAVAN (6.25 PESOS PER KG.)
                MILLING RATE IS ROUGHLY 64% (50 KG. OF PALAY YIELDS
                32 KG. OF RICE).  RETAIL PRICE OF RICE AVERAGED
                (1994) 10.75 PESOS PER KG.
              #{@waitText}
              """
            return

          input: (line) ->
            @transition "mainIntro"
            return

        mainIntro:
          _onEnter: ->
            @message = """


              FOR YOUR FIRST CROP YOU MUST MAKE ALL THE DECISIONS BASED
              ON THE INFORMATION GIVEN IN THE INITIAL INTRODUCTION
              AND INSTRUCTIONS.

              This is the WET season and you have IRRIGATION.
            #{@waitText}
            """
            return

          input: (line) ->
            @transition "setFarmSize"
            return

        setFarmSize:
          _onEnter: ->
            @message = "\nWhat is the size of your farm (IN HECTARES)?\n"  unless @errorFlag
            return

          input: (line) ->
            @data["farmSize"] = @getNumber(@data["farmSize"], line)
            unless @errorFlag
              if @data["farmSize"] >= 5
                @message = "THAT'S PRETTY LARGE FOR A PEASANT IN LUZON."
              else
                @message = ""
              unless @data["runCount"] > 1
                @transition "setWages"
              else
                @transition "startProcessing"
            return

        setWages:
          _onEnter: ->
            @message += "\nWHAT IS THE COST OF OUTSIDE LABOR IN PESOS PER DAY?\n"
            return

          input: (line) ->
            @data["wages"] = @getNumber(@data["wages"], line)
            unless @errorFlag
              if @data["wages"] <= 100
                @message = "Those are terrible wages - you cheapskate!!!\n"
              else if @data["wages"] > 139
                @message = "Very high wages - I doubt you can afford them\n"
              else
                @message = ""
              unless @data["runCount"] > 1
                @transition "setSeedType"
              else
                @transition "startProcessing"
            return

        setSeedType:
          _onEnter: ->
            @message += "\nIS 'LOCAL' OR 'IR64' RICE TO BE PLANTED?\n"
            return

          input: (line) ->
            @data["seedType"] = @getResponse("LOCAL,IR64", @data["seedType"], line)
            unless @errorFlag
              unless @data["runCount"] > 1
                @transition "setSeedCost"
              else
                @transition "startProcessing"
            return

        setSeedCost:
          _onEnter: ->
            @message = "\nWHAT IS THE COST OF SEED IN PESOS/HA?\n"
            return

          input: (line) ->
            @data.costs["seeds"] = @getNumber(@data.costs["seeds"], line)
            unless @errorFlag
              if @data.costs["seeds"] > 680
                @message = "expensive seed - it may not be good - too old\n"
                @data["seedDefectFactor"] = 0.9
              else if @data.costs["seeds"] <= 560
                @message = "cheap seed - why waste time with it - poor germination\n"
                @data["seedDefectFactor"] = 0.9
              else
                @message = ""
                @data["seedDefectFactor"] = 1.0
              unless @data["runCount"] > 1
                @transition "setPesticide"
              else
                @transition "startProcessing"
            return

        setPesticide:
          _onEnter: ->
            @message += "\nDO YOU WISH TO APPLY SYSTEMIC PESTICIDE? 'YES' OR 'NO'\n"
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              if response
                @data["pesticideYieldFactor"] = 1.15
                @data.costs["earlyPestControl"] = 390
                @data.hours["earlyPestControl"] = 1.5 * 8
                unless @data["runCount"] > 1
                  @transition "setFertilizer"
                else
                  @transition "startProcessing"
              else
                @data.costs["earlyPestControl"] = 0
                @data.hours["earlyPestControl"] = 0
                @transition "setIPM"
            return

        setIPM:
          _onEnter: ->
            @message = "\nDO YOU WISH TO USE I.P.M.? 'YES' OR 'NO'\n"
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              if response
                @data["pesticideYieldFactor"] = 1.15
                @data.costs["early_pest_control"] = 390
                @data.hours["early_pest_control"] = 1.5 * 8
              else
                @data["pesticideYieldFactor"] = 1
              unless @data["runCount"] > 1
                @transition "setFertilizer"
              else
                @transition "startProcessing"
            return

        setFertilizer:
          _onEnter: ->
            @message = "\nFOR NITROGEN FERTILIZER (UREA):" + "\n     1. WHAT IS YOUR RATE OF APPLICATION? (KG./HA.)\n"
            return

          input: (line) ->
            @data["fertApplRate"] = @getNumber(@data["fertApplRate"], line)
            unless @errorFlag
              if @data["fertApplRate"] <= 0
                @data["fertApplRate"] = 0
                @transition "setLandPrep"
              else
                if @data["fertApplRate"] > 400
                  @message = """

                    #{@data["fertApplRate"]} KG. OF UREA CONTAINS #{@data.fertNContent()} KG. OF NITROGEN.
                    YOUR CROP CAN NOT USE THAT MUCH.  YOU MAY CAUSE SOME
                    DAMAGE TO THE ECOSYSTEMS IN NEARBY STREAMS.  AT THE
                    VERY LEAST, YOU HAVE WASTED MANY PESOS.


                    """
                else
                  @message = ""
                @transition "setFertilizer2"
            return

        setFertilizer2:
          _onEnter: ->
            @message += "     2. WHAT IS THE COST OF UREA (PESOS/KG.)\n"
            return

          input: (line) ->
            @data["fertCost"] = @getNumber(@data["fertCost"], line)
            unless @errorFlag
              if @data["fertCost"] <= 6.8
                @message = "You can not buy it so CHEAPLY - PLEASE REPEAT"
              else if @data["fertCost"] > 7.4
                @message = "THAT IS EXPENSIVE FERTILIZER - PLEASE REPEAT"
              else
                @data.costs["fertilizer"] = @data["fertApplRate"] * @data["fertCost"]
                @data.hours["fertilizer"] = (1.5 + @data["fertApplRate"]/50) * 8 # Hours of labor needed
                unless @data["runCount"] > 1
                  @transition "setLandPrep"
                else
                  @transition "startProcessing"
            return

        setLandPrep:
          _onEnter: ->
            @data.costs["seedbedPrep"] = @data.hours["seedbedPrep"] =
              @data.costs["landPrep"] = @data.hours["landPrep"] = 0
            @message = "\n" + "do you plan to use 'CARABAO' (WATER BUFFALO) or 'TRACTOR'\n" + "for cropland preparation\n"
            return

          input: (line) ->
            @data["prepMethod"] = @getResponse("CARABAO,TRACTOR", @data["prepMethod"], line)
            unless @errorFlag
              if @data["prepMethod"] is "CARABAO"
                @transition "setCarabaoOwnership"
              else
                @data["ownOrHire"] = "HIRE"
                @message = "\nTHE CURRENT RATE FOR HIRED TRACTOR PLUS DRIVER IS\n" + @TRACTOR_RATE + " PESOS/HOUR.\n"
                @data.costs["seedbedPrep"] = @CARABAO_RATE * @SEEDBED_PREP_HOURS
                @data.costs["landPrep"] = @TRACTOR_RATE * @TRACTOR_HOURS
                unless @data["runCount"] > 1
                  @transition "setWeeding"
                else
                  @transition "startProcessing"
            return

        setCarabaoOwnership:
          _onEnter: ->
            @message = "\ndo you 'OWN' or will you 'HIRE' the carabao\n"
            return

          input: (line) ->
            @data["ownOrHire"] = @getResponse("OWN,HIRE", @data["ownOrHire"], line)
            unless @errorFlag
              if @data["ownOrHire"] is "HIRE"
                @message = "\nTHE CURRENT RATE FOR CARABAO PLUS HANDLER IS " + @CARABAO_RATE + " PESOS/\n" + "HOUR.\n"
                @data.costs["seedbedPrep"] = @CARABAO_RATE * @SEEDBED_PREP_HOURS
                @data.costs["landPrep"] = @CARABAO_RATE * @CARABAO_HOURS
              else
                @data.hours["seedbedPrep"] = @SEEDBED_PREP_HOURS
                @data.costs["landPrep"] = 2.00/6*(@SEEDBED_PREP_HOURS + @CARABAO_HOURS) # (2 pesos/day)/(6 hours/day)x(total hours)
                @data.hours["landPrep"] = @CARABAO_HOURS

              unless @data["runCount"] > 1
                @transition "setWeeding"
              else
                @transition "startProcessing"
            return

        setWeeding:
          _onEnter: ->
            @message += "\n" + "There are three weeding methods available\n" + "     1. HAND WEEDING.\n" + "     2. ROTARY HAND WEEDER.\n" + "     3. GRANULAR HERBICIDE (2,4-D ISOPROPYL ESTER)\n" + "\n" + "THESE METHODS MAY BE EMPLOYED EITHER SINGLY OR IN\n" + "COMBINATION WITH ONE OTHER METHOD. WHEN REQUESTED,\n" + "ENTER NUMBERS CORRESPONDING TO THE METHODS ABOVE,\n" + "FOR INSTANCE '2' MEANS ONE ROTARY WEEDING, '32' MEANS\n" + "2,4-D FOLLOWED BY A ROTARY WEEDING, AND '11' MEANS\n" + "2 HAND WEEDINGS.\n" + @waitText
            return

          input: (line) ->
            @transition "setWeeding2"
            return

        setWeeding2:
          _onEnter: ->
            @message = "\nPlease note the following:\n" + "   A. WEEDS COMPETE VIGOROUSLY WITH RICE AND LOWER\n" + "      THE POTENTIAL YIELD.\n" + "   B. WHEN A HAND WEEDING IS DONE IN COMBINATION WITH\n" + "      ANOTHER METHOD, THE HAND WEEDING IS USUALLY DONE\n" + "      LAST (I.E. '31', NOT '13'!)\n" + "   C. if YOU DESIRE NO WEEDING, ENTER 0 (ZERO).\n" + "\n" + "What weeding method(s) do you wish to use\n"
            return

          input: (line) ->
            @data["weedingMethod"] = @getResponse(@VALID_WEEDING(), @data["weedingMethod"], line)
            unless @errorFlag
              @data.costs["weeding"] = @WEEDING_EFFECTS[@data["weedingMethod"]][2]
              @data.hours["weeding"] = @WEEDING_EFFECTS[@data["weedingMethod"]][1]
              @transition "setMolluscicide"
            return

        setMolluscicide:
          _onEnter: ->
            @snailAttacks++
            @message = "\n" + "Oh my goodness! DURING THE WEED SURVEY MANY BRIGHT RED EGG\n" + "MASSES OF THE GOLDEN SNAIL WERE SEEN IN YOUR FIELDS. If you wish\n" + "you may spray MOLLUSCICIDE or remove the snails and eggs by\n" + "hand. You may also choose to do nothing.\n" + "\n" + "DO YOU WISH TO SPRAY A MOLLUSCICIDE?\n"
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              if response
                @data["snailAttacks"] = 0
                @data.costs["molluscicide"] = 315
                @data.hours["molluscicide"] = 18
                @transition "setWeedingStart"
              else
                @transition "setHandPickSnails"
            return

        setHandPickSnails:
          _onEnter: ->
            @snailAttacks++
            @message = "\nDO YOU WISH TO HAND PICK YOUR FIELDS?\n"
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              if response
                @snailAttacks = 0
                @data.costs["molluscicide"] = 0
                @data.hours["molluscicide"] = 60
              @transition "setWeedingStart"
            return

        setWeedingStart:
          _onEnter: ->
            @message = "\n" + "HOW MANY DAYS AFTER TRANSPLANTING IS THE WEEDING\n" + "OPERATION STARTED\n"
            return

          input: (line) ->
            @weedingDaysStart = @getNumber(@weedingDaysStart, line)
            @transition "setThreshing"  unless @errorFlag or @data["runCount"] > 1
            @transition "startProcessing" if @data["runCount"] > 1

            return

        setThreshing:
          _onEnter: ->
            @message = "\nIs the threshing to be done by 'HAND' or by 'MACHINE'\n"
            return

          input: (line) ->
            @data["threshingMethod"] = @getResponse("HAND,MACHINE", @data["threshingMethod"], line)
            @transition "setMarketValue" unless @errorFlag or @data["runCount"] > 1
            @transition "startProcessing" if @data["runCount"] > 1
            return

        setMarketValue:
          _onEnter: ->
            @message = "\n" + "What is the market value of ROUGH RICE (PESOS/KG.)\n"
            return

          input: (line) ->
            @data["price"] = @getNumber(@data["price"], line)
            unless @errorFlag
              if @data["price"] > 6.35
                @message = "\nTHAT'S WAY ABOVE THE LATEST REPORTED MARKET PRICE.\n" + "PLEASE REPEAT THE PRICE PER KILOGRAM.\n"
              else
                @transition "startProcessing"
            return

        startProcessing:
          _onEnter: ->
            @data["riceYield"] =
              @data["pesticideYieldFactor"] * @data["seedDefectFactor"] *
              @WEEDING_EFFECTS[@data["weedingMethod"]][0] *
              ( (@data.ureaFactor1() * Math.pow(@data.fertNContent(), 2)) +
                (@data.ureaFactor2() * @data.fertNContent()) + 1 ) *
              @data.seedYield()
            @data["riceYield"] = 0 if @data["riceYield"] < 0

            @message = "\n\n\nrandomizing events...\n    calculating costs and yields... DONE! \n\n"
            if @data["prepMethod"] is "TRACTOR"
              @data["riceYield"] *= 1.07
              @message += """

                YOU DID A BEAUTIfUL JOB PREPARING THE FIELDS.

                """

            if @data["weedingDaysStart"] >= 20
              @message += """
                    YOU WAITED TOO LONG TO START THE WEEDING. YOU HAVE 
                    WASTED YOUR TIME AND YOUR LABOR.  TOUGH LUCK!
                """
              @data["riceYield"] *= 0.7
            else if @data["weedingDaysStart"] >= 14
              @message += """
                    YOU HAVE WAITED SO LONG TO START THE WEEDING THAT IT IS
                    ONLY PARTLY SUCCESSFUL.  BETTER LUCK NEXT TIME.
                """
              @data["riceYield"] *= 0.85

            @message += "\n"

            if @data["seedType"] is "IR64"
              r = Math.floor(Math.random() * 4)/100.0    # IR64 IS QUITE RESISTANT
              @message += "LOOKS AS if BACTERIAL BLIGHT AND BLAST HAVE CAUSED ABOUT\n"
            else
              r = Math.floor(Math.random() * 13)/100.0    # local rice not resistant
              @message += "UNFORTUNATELY, GRASSY STUNT AND TUNGRO HAVE CAUSED ABOUT\n"

            @message += "#{100 * r} PERCENT LOSS OF POTENTIAL YIELD.\n"

            @data["riceYield"] *= (1 - r)

            @message += """

              A VERY STRONG TYPHOON IS REPORTED HEADED TOWARD YOUR AREA
              FROM THE SOUTH-EAST. TIE DOWN YOUR HOUSE AND PRAY THAT THE
              STORM MISSES YOUR FARM.


              What is YOUR prayer?
              """
            return

          input: (line) ->
            @transition "processing2"
            return

        processing2:
          _onEnter: ->
            @message = ""
            if @data["snailAttacks"] >= 1
              @message += """

                You didn't get rid of the snails last year. Too bad - they have
                destroyed MANY plants this year. Better try escargot with garlic.

                """
              r4 = Math.floor(12 + (Math.random() * 6))
              @data["riceYield"] *= (1 - 0.01 * r4)


            @message += """

                THE FARM SPECIALIST ESTIMATES YOUR CROP AS IT NOW STANDS
                AT #{Math.round(10 * @data["riceYield"] / 50) / 10} CAVANS PER HECTARE.

                Do you think that SHE is correct?
            """
            return

          input: (line) ->
            @transition "processing3"
            return

        processing3:
          _onEnter: ->
            @message = """

                       W E L L   DON'T COUNT ON THAT FOR HARVEST!!!!

              """
            unless @data["skipIntro"]

              @message += """

                Brown plant hopper IS A VERY COMMON INSECT PEST. LOSS OF CROP
                MAY BE ANYWHERE FROM 0% TO 15% if INSECTICIDE IS USED
                AS SOON AS INFESTATION IS DISCOVERED (DEPENDING UPON DEGREE
                OF INFESTATION). However, if CONTROLS ARE NOT USED, LOSSES
                MAY RUN AS HIGH AS 30%. ON A SLIDING SCALE FROM 0 TO 10:

                0 (NONE)...............5 (AVERAGE)..............10 (SEVERE)

                """
            @message += "\n"
            
            @insectAttack = 0
            unless @data.costs["earlyPestControl"]
              @message += """
                DESPITE THE EARLY PEST CONTROL PROGRAM YOU HAVE SOME SIGNS OF
                INSECT ATTACK. (BUT MUCH LESS THAN YOUR NEIGHBOR TO THE
                EAST). YOU CAN FIGHT THE ATTACK WITH A SPRAYED INSECTICIDE.

                """
              @insectAttack = Math.floor(Math.random() * 5) + 1
              if @data["seedType"] is "IR64"
                @insectAttack /= 2
              else if @insectAttack <= 0
                @message += """
                  YOUR EARLY PEST CONTROL PROGRAM WAS SO EFFECTIVE THAT
                  """
            else
              @insectAttack = Math.floor(Math.random() * 10) + 1
              @insectAttack /= 2 if @data["seedType"] is"IR64"         # IR64 resists insect attack.

            @message += """
              THE DEGREE OF INSECT ATTACK THIS YEAR IS #{@insectAttack}

              DO YOU WISH TO SPRAY AN INSECTICIDE?
              """
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              if response
                @data.costs["insecticide"] = 1.5 * 112           # cost of insecticide, 1.5 qts azodrin
                @data.hours["insecticide"] = 2*8                   # 2 days labor to apply insecticide
              else
                @data.costs["insecticide"] = 0
                @data.hours["insecticide"] = 0
                @insectAttack *= 2
              @data["riceYield"] *= (1.0 - 0.015 * @insectAttack)
              @transition "processing4"
            return

        processing4:
          _onEnter: ->
            @message = ""
            unless @data["skipIntro"]

              @message += """

                BEING A GOOD ECOLOGY MINDED FARMER YOU DID NOT KILL OR 
                POISON THE BIRDS. THEY ARE NOW EATING THE RIPENING GRAIN.
                """
            @message += """

              DO YOU WISH TO PROTECT YOUR CROP AGAINST BIRDS?
              """
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              r3 = (Math.random() * 6) + 1
              @message = ""
              if response
                if @data.runCount <= 4
                  @message += """

                    YOU AND YOUR SONS WILL TAKE TURNS STANDING IN THE FIELDS
                    WAVING FLAGS AND USING SLINGSHOTS ON THE LITTLE PESTS.
                    """
                @data.hours["birdRepelling"] = 14 * 4
                r3 = Math.floor(r3/2 + 0.5)
                @message += """

                  YOUR BIRD LOSS HAS BEEN REDUCED TO ONLY #{r3} PERCENT!

                  """

              else
                @data.hours["birdRepelling"] = 0
                @message += """

                  OH WELL, THEY WILL GET ONLY ABOUT #{r3} PERCENT.

                  """

              @data["riceYield"] *= (1.0 - 0.015 * r3)
              @transition "processing5"
            return

        processing5:
          _onEnter: ->
            @data["typhoonLevel"] = Math.floor(Math.random() * 10)

            if @data["typhoonLevel"] <= 4
              @message = "\nYour prayer has worked. The typhoon missed your area!\n"
            else
              @message = "\nSECOND TYPHOON WARNING. IT'S COMING YOUR WAY.\n"

            @message += """

              RATS ARE ATTACKING RICE IN SOME FIELDS TO THE SOUTH OF YOUR
              FARM - DO YOU WISH TO SET OUT POISON?
              """
            return

          input: (line) ->
            response = @getYesNo(line)
            unless @errorFlag
              @data["ratDamage"] = Math.abs(Math.sqrt(-2 * Math.log(Math.random()))*Math.sin(2 * Math.PI * Math.random()))     # Rat loss
              @message = ""
              if response
                @transition "raticides"
              else
                @data.costs["rodenticide"] = 0
                @data.hours["rodenticide"] = 0
                @transition "processing6"
            return

        raticides:
          _onEnter: ->
            @message = ""
            unless @data["skipIntro"]
              @message += """

                ACUTE RATICIDES GIVE SPECTACULAR RESULTS BUT IN THE LONG
                RUN CHRONIC POISONS ARE MORE EFFECTIVE AS WELL AS MORE
                COSTLY AND TIME CONSUMING,
                """

            @message += """

              DO YOU WISH TO USE 'CHRONIC' OR 'ACUTE' POISON?
              """
            return

          input: (line) ->
            @data["poison"] = @getResponse("CHRONIC,ACUTE", @data["poison"], line)
            unless @errorFlag
              if @data["poison"] is "CHRONIC"
                unless @data["skipIntro"]
                  @message = """

                    YOU HAVE CHOSEN WARFARIN IN .5% CONCENTRATION. YOU MUST
                    MIX IT WITH 19 PARTS OF CEREAL, WRAP IT IN BANANA LEAVES
                    AND PLACE IT ALONG RAT RUNS.  DO THIS EACH DAY FOR 2 WEEKS.
                    """

                @data.costs["rodenticide"] = 67.5   # cost of warfarin /ha
                @data.hours["rodenticide"] = 14 * 3 # Hours of labor to apply warfaran/ha.
              else
                unless @data["skipIntro"]
                  @message = """

                    YOU WILL USE ZINC PHOSPHIDE. MIX IT WITH 150 PARTS OF 
                    BAIT AND PLACE IT ON RAT RUNS. BE CAREFUL - ONCE THIS REACHES
                    THE STOMACH (RAT OR HUMAN) IT RELEASES PHOSPHINE GAS
                    CAUSING TOTAL PARALYSIS OF THE CENTRAL NERVOUS SYSTEM. IT
                    IS VERY DANGEROUS. SOMEONE MAY GET HURT. RATS POISONED THIS
                    WAY ARE RENDERED INEDIBLE!
                    """
                @data.costs["rodenticide"] = 48     # Cost / ha for zinc phosphide
                @data.hours["rodenticide"] = 3 * 3  # Hours to apply zinc/ha.

              @transition "processing6"
            return
      
        processing6:
          _onEnter: ->
            
            #      COMPUTE CROP LOSS WITH RATICIDE
            if @data.costs["rodenticide"] > 0
              @data["ratDamage"] = Math.floor(@data["ratDamage"] *5)

              @message = """

                YOU HAVE CUT YOUR POTENTIAL RAT LOSS DRAMATICALLY.
                CONGRATULATIONS! ONLY #{@data["ratDamage"]} PERCENT OF THE CROP WAS LOST.

                """

            #      COMPUTE CROP LOSS WITHOUT RATICIDE
            else
              @data["ratDamage"] = Math.floor(@data["ratDamage"] * 15)
              
              if @data["ratDamage"] > 24
                @message = """

                  THE PALAY WAS DOING WELL - BUT, MAN - DID YOU GET HIT BY
                  RATS!! 10 DAYS BEFORE HARVEST THEY DESCENDED LIKE THE PLAGUE
                  AND RUINED #{@data["ratDamage"]} PERCENT OF YOUR STAND.  EGAD!!

                  """
              else if @data["ratDamage"] > 12
                @message = """

                  CROP LOOKED GOOD BUT IN THE WEEK BEFORE HARVEST MANY RATS
                  CONVERGED ON THE FIELDS AND DESTROYED #{@data["ratDamage"]} PERCENT OF
                  THE STANDING CROP.  BETTER LUCK NEXT YEAR!!

                  """
              else
                @message = """

                  YOU WERE VERY LUCKY THIS SEASON, PALAY GREW WELL AND YOU
                  LOST ONLY #{@data["ratDamage"]} PERCENT OF THE CROP TO RATS.

                  """

            @data["riceYield"] *= (1 - 0.01 * @data["ratDamage"])  # Total crop x (1-destroyed by rats)

            # 
            #      ***** TYPHOON *****
            # 
            if @data["typhoonLevel"] > 8
              @message += """

                TOUGH LUCK. THE TYPHOON PASSED THROUGH YOUR PROVINCE AND
                THE CROP IS IN A TERRIBLE MESS.

                """
              @data["riceYield"] *= 0.65           # 35% yield loss
            else if @data["typhoonLevel"] > 4
              @message += """

                THE TYPHOON PASSED CLOSE BY. HIGH WIND AND HEAVY RAIN CAUSED
                GREAT LODGING BUT MUCH OF THE CROP CAN BE SAVED.

                """
              @data["riceYield"] *= 0.80           # 20% yield loss

            #
            # 
            #                  **** LOW WAGE LOSS ****
            # 
            if @data["wages"] < 90
              @message += """

                Your wages are so low that it is almost impossible to hire
                anyone. Work has been delayed and yield has suffered!

                """

              @data["riceYield"] *= 0.75           # 35% yield loss
            else if @data["wages"] <= 100
              @message += """

                Your wages are so low that it is almost impossible to hire
                anyone. Work has been delayed and yield has suffered!

                """
              @data["riceYield"] *= 0.88           # 20% yield loss

            @calculateFinalDetails()

            @message += """
              
              WOULD YOU LIKE A COMPLETE COST-YIELD ANALYSIS?
              """
            return

          input: (line) ->
            @costYield = @getYesNo(line)
            unless @errorFlag
              @transition "header"
            return
      
        header:
          _onEnter: ->
            @message = """



              ----------------------------------------------------------------



                     ECONOMICS OF RICE PRODUCTION IN THE PHILIPPINES



              RICE TYPE: #{@data["seedType"]}

              FARM SIZE: #{@data["farmSize"]} HECTARES
              TOTAL YIELD: #{Math.round(@totalYield)} KILOGRAMS

                            (#{Math.round(10*@totalYield/50.0)/10} CAVANS PER HA.)


              .........................
              #{@waitText}
              """

          input: (line) ->
            if @costYield
              @transition "costYield"
            else
              @transition "summary"
            return

        costYield:
          _onEnter: ->
            @message = """

                                                      Land Reform Owner
              OPERATING COST:

              MATERIAL INPUTS

              """
            if @totalCosts("earlyPestControl") > 0
              @message += sprintf(@FMT2, " MATERIALS - EARLY PEST CONTROL", @totalCosts("earlyPestControl")) + "\n"

            @message += sprintf(@FMT2, " SEEDS(50 KG/HA)", @totalCosts("seeds")) + "\n"

            if @totalCosts("fertilizer") > 0
              @message += """
                    FERTILIZER (UREA) @#{ @data["fertCost"] } PESOS/KG.
                #{sprintf(@FMT2, "  ", @totalCosts("fertilizer"))}
                
                """

            if @totalCosts("insecticide") > 0
              @message += sprintf(@FMT2, "INSECTICIDE @112 PESOS/BOTTLE", @totalCosts("insecticide")) + "\n"

            if @totalCosts("weeding") > 0
              @message += sprintf(@FMT2, "HERBICIDE (.8KG AI/HA)", @totalCosts("weeding")) + "\n"

            if @totalCosts("rodenticide") > 0
              @message += sprintf(@FMT2, "RODENTICIDE AND BAIT", @totalCosts("rodenticide")) + "\n"

            if @totalCosts("molluscicide") > 0
              @message += sprintf(@FMT2, "MOLLUSCICIDE", @totalCosts("molluscicide")) + "\n"

            @message += "\n#{@waitText}"

          input: (line) ->
            @transition "costYield2"
            return

        costYield2:
          _onEnter: ->
            @message = """

              SEEDBED PREPARATION -- 4 DAYS WORKER AND\n
              """
            if @data["ownOrHire"] is "HIRE"
              @message += """
                    CARABAO AT #{6 * @CARABAO_RATE} PESOS PER DAY
                #{sprintf(@FMT2, "  ", @totalCosts("seedbedPrep"))}
                """
            else
              @message += """
                    CARABAO. SEE 'LAND PREPARATION' FOR
                    COST OF OWNING ANIMAL
                #{sprintf(@FMT2, "OPERATOR'S LABOR", @labor("seedbedPrep"))}
                """
            @message += "\n#{@waitText}"

          input: (line) ->
            @transition "costYield3"
            return

        costYield3:
          _onEnter: ->
            @message = """

              LAND PREPARATION -- PLOWING AND HARROWING

              """
            if @data["prepMethod"] is "TRACTOR"
              @message += """
                    #{@data["farmSize"] * @TRACTOR_HOURS / 8} TRACTOR DAYS @#{8 * @TRACTOR_RATE} PESOS/DAY
                #{sprintf(@FMT2, "  ", @totalCosts("landPrep"))}
                """
            else
              if @data["ownOrHire"] is "HIRE"
                @message += """
                     #{@data["farmSize"] * @CARABAO_HOURS / 6} DAYS FOR CARABAO
                      AT #{6 * @CARABAO_RATE} PESOS PER DAY
                  #{sprintf(@FMT2, "  ", @totalCosts("landPrep"))}
                  """
              else
                @message += """
                  #{sprintf(@FMT2, "COST OF OWNING CARABAO", @totalCosts("landPrep"))}
                  #{sprintf(@FMT2, "OPERATORS LABOR", @labor("landPrep"))}
                  """
            @message += "\n#{@waitText}"

          input: (line) ->
            @transition "costYield4"
            return

        costYield4:
          _onEnter: ->
            @message = "\n"
            if @labor("earlyPestControl") > 0
              @message += """
                #{sprintf(@FMT2, "LABOR - EARLY PEST CONTROL", @labor("earlyPestControl"))}
                
                """
            if @labor("molluscicide") > 0
              @message += sprintf(@FMT, "LABOR FOR SNAIL REMOVAL", @labor("molluscicide")) + "\n"

            if @totalCosts("fertilizer") > 0
              @message += """
                COSTS OF APPLYING FERTILIZER
                    #{@data["farmSize"] * @data.hours["fertilizer"] / 8} PERSON DAYS @#{@data["wages"]} PESOS/DAY
                #{sprintf(@FMT2, "  ", @labor("fertilizer"))}
                """

            @message += """

              #{sprintf(@FMT, "TRANSPLANTING - 18 WORK DAYS/HA", @labor("transplanting"))}
              #{@waitText}
              """

          input: (line) ->
            @transition "costYield5"
            return

        costYield5:
          _onEnter: ->
            @message = "\n"
            if @labor("insecticide") > 0
              @message += """
               
                APPLICATION OF PESTICIDE
                    2 DAYS PER HA. AT #{@data["wages"]} PESOS PER DAY
                #{sprintf(@FMT2, "  ", @labor("insecticide"))}\n
                """
            unless @data["weedingMethod"] is "0"
              @message += """
                WEEDING COSTS -- METHOD #{@data["weedingMethod"]}
                    #{@data.hours["weeding"]} HOURS PER HECTARE
                #{sprintf(@FMT2, "  ", @labor("weeding"))}\n
                """

            if @labor("birdRepelling") > 0
              @message += sprintf(@FMT, "CHILD LABOR FOR BIRD WATCH", @labor("birdRepelling") / 2) + "\n"

            if @labor("rodenticide") > 0
              @message += sprintf(@FMT, "APPLICATION OF RODENTICIDE", @labor("rodenticide")) + "\n"

            @message += "#{@waitText}"

          input: (line) ->
            @transition "costYield6"
            return

        costYield6:
          _onEnter: ->
            @message = """

              HARVESTING COSTS
              #{sprintf(@FMT2, "HARVEST RATE - 32 KG/WORK HR", @labor("harvesting"))}
              
              THRESHING

              """
            if @data["threshingMethod"] is "HAND"
              @message += sprintf(@FMT2, "RATE ABOUT 40 KG/HR", @labor("threshing")/2) + "\n"
            else
              @message += sprintf(@FMT2, "COST BY MACHINE - 5% OF YIELD", @totalCosts("threshing")) + "\n"
            @message += """

              #{sprintf(@FMT, "HAULING COST - .012 PESOS/KG", @totalCosts("hauling"))}
              #{@waitText}
              """

          input: (line) ->
            @transition "costYield7"
            return

        costYield7:
          _onEnter: ->
            @message = """

                                                   ---------------------
              #{sprintf(@FMT2, "   TOTAL OPERATING COSTS", @operatingCosts)}
              
              NOTE, HOWEVER, THAT A CONSIDERABLE PORTION OF THE FARMER'S
              COSTS ARE IN TERMS OF personal AND family LABOR.


              .........................
              #{@waitText}
              """

          input: (line) ->
            @transition "costYield8"
            return

        costYield8:
          _onEnter: ->
            @message = """


              FIXED COSTS
              #{sprintf(@FMT2, "IRRIGATION FEES - 945 PESOS/HA", @totalCosts("irrigation"))}
              #{sprintf(@FMT2, "LAND TAX - 1050 PESOS/HA", @totalCosts("landTax"))}
              #{sprintf(@FMT2, "PAY MORTGAGE - 4% OVER 20 YEARS", @mortgage)}
                                                   ---------------------
              
              #{sprintf(@FMT, "T O T A L  C O S T S", (@operatingCosts + @totalCosts("irrigation") + @totalCosts("landTax") + @mortgage))}

              . . . . . . . . . . . . . . . . . . . .

              #{@waitText}
              """

          input: (line) ->
            @transition "summary"
            return

        summary:
          _onEnter: ->
            console.log this
            totalOperatingCosts = (@operatingCosts + @totalCosts("irrigation") + @totalCosts("landTax") + @mortgage)
            profit = (@totalYield * @data["price"]) - totalOperatingCosts
            profit = Math.round(profit * 100) / 100

            @message = """

              S U M M A R Y
                                                      LAND REFORM OWNER
                TOTAL VALUE OF #{Math.round(@totalYield * 100) / 100} KILOGRAMS
                OF PALAY AT #{ @data["price"] }
                PESOS PER KILOGRAM                        #{Math.round(@totalYield * @data["price"] * 100) / 100}

                LESS TOTAL EXPENSES                       #{Math.round(totalOperatingCosts * 100) / 100}
                                                   --------------------

               N E T  P R O F I T                         #{profit}

                 Feels good to own your own land - DOESN'T IT???


              """
            if profit < @data["farmSize"] * 2800
              @message += """
                YOU ARE ONE HECK OF A POOR FARMER - YOUR KIDS WILL STARVE
                AT THAT RATE.  YOU MADE AT LEAST ONE terrible DECISION.
                YOU HAD BETTER CORRECT IT BEFORE NEXT SEASON.

                """
            else if profit < @data["farmSize"] * 4500
              @message += """
                THAT IS NOT A GOOD YEAR AT ALL. BETTER IMPROVE YOUR TECHNIQUE
                OR YOU WILL LOSE THE LAND YOU WORKED SO HARD TO EARN

                """
            @message += """
              ----------------------------------------------------------------
              #{@waitText}
              """

          input: (line) ->
            @transition "runAgain"
            return

        runAgain:
          _onEnter: ->
            @message = "\n\n"
            unless @data["skipIntro"]
              @message += """
                YOU WILL NOW HAVE THE OPTION OF RERUNNING THE PROGRAM.
                YOU MAY KEEP THE SAME RICE TYPE OR YOU MAY CHANGE.
                IN EITHER CASE THE INPUTS WILL REMAIN AS FOR THE FIRST
                CROP UNTIL YOU DECIDE TO ADOPT A DifFERENT TECHNOLOGY.
                """
            @message += """


              DO YOU WISH TO RUN THE PROGRAM AGAIN?


              """

          input: (line) ->
            response = @getYesNo(line)

            unless @errorFlag
              if response
                @transition "changeFactors"
              else
                @transition "goodbye"
            return

        changeFactors:
          _onEnter: ->
            @data["runCount"]++
            @message = """
              WHICH FACTOR DO YOU WISH TO CHANGE

              ENTER '0' (ZERO) if YOU DESIRE NOT TO CHANGE ANYTHING.
              OTHERWISE ENTER a number from the list below.
              1   'SIZE OF FARM'
              2   'COST OF OUTSIDE LABOR'
              3   'TYPE OF RICE (SEED) USED'
              4   'COST OF SEED'
              5   'USE OF SYSTEMIC PESTICIDE, I.P.M., OR NOTHING' 
              6   'COST AND AMOUNT OF NITROGEN FERTILIZER'
              7   'METHOD OF CROPLAND PREPARATION' 
              8   'METHOD OF WEEDING AND SNAIL PROTECTION'
              9   'METHOD OF THRESHING' 
              10   'MARKET VALUE OF ROUGH RICE'

              Remember, in a controlled experiment you can change only
              ONE factor at a time! WHICH ONE???
              """

          input: (line) ->
            @rerunFactor = @getResponse([1..10].join(","), @rerunFactor, line)

            unless @errorFlag
              switch @rerunFactor
                when "0" then @transition "startProcessing"
                when "1" then @transition "setFarmSize"
                when "2" then @transition "setWages"
                when "3" then @transition "setSeedType"
                when "4" then @transition "setSeedCost"
                when "5" then @transition "setPesticide"
                when "6" then @transition "setFertilizer"
                when "7" then @transition "setLandPrep"
                when "8" then @transition "setWeeding"
                when "9" then @transition "setThreshing"
                when "10" then @transition "setMarketValue"
            return

        goodbye:
          _onEnter: ->
            @message = """



                     THANKS FOR PLAYING RICEGROW!



              """

          input: (line) ->
            return
      #
      # Other utility functions
      #
      waitText: "\nPress Enter to continue...\n"
      getYesNo: (line) ->
        @errorFlag = false
        response = line.trim().toUpperCase()
        if response is "YES" or response is "Y" or response is "NO" or response is "N"
          return response is "YES" or response is "Y"
        else
          @errorFlag = true
          @message = "Please enter 'YES' or 'NO'"
        return

      getNumber: (original, line) ->
        @sameFlag = false
        @errorFlag = false
        response = line.trim().toUpperCase()
        if response is "SAME"
          if original isnt null
            @sameFlag = true
            return original
          else
            @message = "You cannot use the same value"
            @errorFlag = true
        else
          unless isNaN(parseFloat(response))
            return parseFloat response
          else
            @message = "Please type a number"
            @errorFlag = true
        return

      getResponse: (valid, original, line) ->
        @sameFlag = false
        @errorFlag = false
        response = line.trim().toUpperCase()
        if response is "SAME"
          if original isnt null
            @sameFlag = true
            return original
          else
            @message = "You cannot use the same value"
            @errorFlag = true
        else
          if _.contains(valid.split(","), response)
            return response
          else
            @message = "That is not a legal response. Please retype."
            @errorFlag = true
        return
      
      calculateFinalDetails: ->
        
        # 
        #  HARVESTING
        # 
        @data.hours["harvesting"] = 0.0311 * @data["riceYield"] # .0311=number of hours to harvest 1kg.

        # 
        # 
        #  THRESHING
        # 
        @data.costs["threshing"] = @data.hours["threshing"] = 0

        if @data["threshingMethod"] is "MACHINE"
          @data["riceYield"] *= 0.97                 # 3% extra loss for machine use
          @data.costs["threshing"] = 0.05 * @data["riceYield"] * @data["price"]   # 5% of crop goes to machine owner
        else
          @data.hours["threshing"] = 0.05 * @data["riceYield"]

        # 
        # 
        #  HAULING
        # 
        @data.costs["hauling"] = 0.012 * @data["riceYield"]

        # 
        #      ******************************
        #      *     COMPUTE TOTAL COST     *
        #      ******************************
        # 
        subtotal = @totalCosts("earlyPestControl")  # Materials, early pest control
        subtotal += @totalCosts("seeds")              # Seeds
        subtotal += @totalCosts("fertilizer")         # Fertilizer
        subtotal += @totalCosts("insecticide")        # Insecticide
        subtotal += @totalCosts("weeding")            # Herbicides for weeding
        subtotal += @totalCosts("rodenticide")        # Rodenticide and bait
        subtotal += @totalCosts("molluscicide")       # Molluscicide
        subtotal += @totalCosts("seedbedPrep") +
          @labor("seedbedPrep")                     # Cost for seedbed preparation
        subtotal += @totalCosts("landPrep") +
          @labor("landPrep")                        # Cost for land preparation
        subtotal += @labor("earlyPestControl")       # Labor for ealry pest control
        subtotal += @labor("fertilizer")               # Labor cost of applying fertilizer
        subtotal += @labor("transplanting")            # Cost of transplanting
        subtotal += @labor("insecticide")              # Labor cost for applying insecticide
        subtotal += @labor("weeding")                  # Weeding cost
        subtotal += @labor("molluscicide")             # Labor for snail treatment
        subtotal += @labor("birdRepelling") / 2       # Labor for bird watch 1/2price
        subtotal += @labor("rodenticide")              # Application of rodenticide
        subtotal += @labor("harvesting")               # Harvesting cost
        subtotal += @totalCosts("threshing")          # Cost for machine threshing
        subtotal += @labor("threshing")                # Cost for hand threshing
        subtotal += @totalCosts("hauling")            # Hauling cost
        @operatingCosts = subtotal                    # Total operating costs
        
        @totalYield = @data["riceYield"] * @data["farmSize"]
        @mortgage = (@totalYield * @data["price"]) * 4 * 0.07
        
        
    )
    console1 = $("#console1")
    controller1 = console1.console(
      promptLabel: "> "
      commandHandle: (line) ->
        gameFsm.handle "input", line
        gameFsm.message

      autofocus: true
      animateScroll: true
      welcomeMessage: "    ARE YOU FAMILIAR ENOUGH WITH THE PROGRAM TO WISH TO SKIP\n    ALL PRELIMINARIES?  "
    )
    return

  return
) jQuery, _
