(function($, _){
  $(function() {
    var gameFsm = new machina.Fsm({
      initialState: "startGame",
      data: {
        gameStarted: false,
        costs: { },
        hours: { },
        fertNContent: function() {
          return 0.45 * this.fertApplRate;
        }
      },
      states: {
        "startGame" : {
          "input" : function(line) {
            var response = this.getYesNo(line);
            if (!this.errorFlag) {
              this.data["skipIntro"] = response;
              if (response) {
                this.transition("mainIntro");
              } else {
                this.transition("intro1");
              }
            } 
          }
        },
        "intro1": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "\n" +
              "Welcome to the real world!  YOU ARE TO PLAY THE ROLE OF A\n" +
              "   SMALL-TIME RICE FARMER IN THE PHILIPPINES.  YOU HAVE\n" +
              "   CONTROL OVER MOST OF THE FACTORS WHICH INFLUENCE YOUR\n" +
              "   OUTPUT.  THE IDEA IS TO RAISE SEVERAL SUCCESSIVE CROPS,\n" +
              "   ALWAYS TRYING TO INCREASE YOUR RETURNS TO LABOR AND\n" +
              "   CAPITAL. A FAILURE FOR A SINGLE YEAR MAY MEAN A MAJOR\n" +
              "   CRISIS FOR YOU AND FOR THE FAMILY.  GOOD LUCK!!!\n" +
              "\n" +
              "\n" +
              "YOU ARE A NEW OWNER AS A RESULT OF LAND REFORM.\n" +
              "YOUR LAND IS IRRIGATED.\n" +
              "YOUR HEADMAN WOULD LIKE YOU TO RAISE 'IR64' WHICH IS SAID TO\n" +
              "ACHIEVE VERY HIGH YIELDS, BUT YOU ARE FAMILIAR WITH 'LOCAL' RICE\n" +
              "AND HESITATE TO EXPERIMENT WITH NEW KINDS OF SEEDS.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("intro2");
          }
        },
        "intro2": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "\n" +
              "    FIRST, A FEW TERMS YOU SHOULD KNOW:\n" +
              "      HECTARE (HA.) = 10,000 SQ. METERS (2.47 ACRES)\n" +
              "      KILOGRAM (KG.) = 2.2 POUNDS\n" +
              "      PESO = U.S. $0.023 ($1 = 44 PESOS)\n" +
              "      CAVAN = VOLUME MEASURE - ROUGHLY 50 KG. OF PALAY\n" +
              "      PALAY = THE TERM FOR THRESHED BUT UNHUSKED RICE\n" +
              "      IR64 = A HIGH YIELDING RICE VARIETY FIRST RELEASED IN 1985\n" +
              "      LODGING = PLANT FALLS OVER FROM TOO WEAK STEM.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("factors1");
          }
        },
        "factors1": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "\n" +
              "Factors you can control include (among others) the following 10:\n" +
              "\n" +
              "     1. SIZE OF FARM (IN HECTARES).\n" +
              "  THE MEAN FARM SIZE IN CENTRAL LUZON IS ABOUT 1.8 HA. BUT\n" +
              "  SOME FARMS ARE A FRACTION OF A HA. WHILE OTHERS ARE AS\n" +
              "  LARGE AS 50 HECTARES.\n" +
              "\n" +
              "     2. COSTS OF OUTSIDE LABOR (IN PESOS/DAY).\n" +
              "  LABOR COSTS PER DAY FOR FARM WORK (1998) VARY FROM PESOS\n" +
              "  105 TO PESOS 125 DEPENDING ON LOCATION AND SEASON. SOME\n" +
              "  SMALL SNACK FOODS ARE NORMALLY ADDED TO THIS COST.\n" +
              "\n" +
              "     3. TYPE OF RICE (SEED) USED.\n" +
              "  IR64 HAS GREAT POTENTIAL, BUT MOST FARMERS ARE FAMILIAR\n" +
              "  WITH LOCAL VARIETIES.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("factors2");
          }
        },
        "factors2": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "     4. COST OF SEED.\n" +
              "  SEEDS ARE USED AT THE RATE OF 1 CAVAN PER HA. OF FARM.\n" +
              "  ORDINARY HYV SEED COSTS 570 - 630 PESOS PER CAVAN.\n" +
              "  GOVERNMENT INSPECTED SEED OF VERY GOOD QUALITY SELLS AT \n" +
              "  ABOUT 675 PESOS. SOMETIMES A FARMER WITH SURPLUS RICE\n" +
              "  WILL OFFER A 'DEAL' - SEED FOR much LOWER COST. SOME\n" +
              "  SHARP BUSINESS TYPES MAY OFFER 'SELECTED' SEED FOR AS\n" +
              "  MUCH AS 700 - 750 PESOS.\n" +
              "\n" +
              "  LET'S ASSUME THAT OUR FARMER USES A VERY EFFICIENT SEED\n" +
              "  RATE OF ONE CAVAN PER HECTARE!\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("factors3");
          }
        },
        "factors3": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "     5. USE OF SYSTEMIC PESTICIDE, I.P.M., OR NOTHING.\n" +
              "  I.P.M. (OR INTEGRATED PEST MANAGEMENT) INVOLVES CAREFUL\n" +
              "  CULTIVATION TECHNIQUES, THE ENCOURAGEMENT OF RICE PEST PREDATORS,\n" +
              "  AND CONSTANT MONITORING OF PEST INFESTATIONS. if THESE EXCEED\n" +
              "  ACCEPTABLE LEVELS  A LIMITED SPRAY PROGRAM IS UNDERTAKEN.\n" +
              "    SYSTEMIC PESTICIDES ARE DESIGNED TO RID YOUR FIELDS OF\n" +
              "  INSECTS. THIS OFTEN INCLUDES PEST PREDATORS AS WELL AS STEM-\n" +
              "  BORERS, ARMY WORMS AND LEAF HOPPERS.\n" +
              "    SYSTEMICS ARE APPLIED AT TRANSPLANTING. (THIS IS WELL BEFORE\n" +
              "  ANY INSECT ATTACK WILL BE OBSERVED). SYSTEMICS ARE COSTLY\n" +
              "  BUT EFFECTIVE IN CUTTING LOSS FROM MANY INSECTS. MOST\n" +
              "  FARMERS GAMBLE ON A LIGHT ATTACK AND DON'T USE SYSTEMICS.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("factors4");
          }
        },
        "factors4": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "     6. COST AND AMOUNT OF NITROGEN FERTILIZER.\n" +
              "  UREA IS THE CHEAPEST FORM OF NITROGEN. BY WEIGHT IT HAS\n" +
              "  45 PERCENT N. A BAG OF UREA WEIGHS 50 KG.; AND COSTS BETWEEN\n" +
              "  PESOS 350 - 370 (1998).\n" +
              "\n" +
              "     7. METHOD OF CROPLAND PREPARATION.\n" +
              "  USE OF THE CARABAO IS TRADITIONAL, BUT MANY FARMERS TODAY\n" +
              "  ARE HAVING THEIR FIELDS CUSTOM PLOWED BY SMALL TRACTOR.\n" +
              "  ADVANTAGES OF THIS ARE SPEED AND BETTER WEED CONTROL.\n" +
              "\n" +
              "     8. METHOD OF WEEDING AND HERBICIDE APPLICATIONS.\n" +
              "  WEEDING TOO HAS TRADITIONALLY BEEN DONE BY HAND.\n" +
              "  THE USE OF HERBICIDES IS A RECENT INNOVATION.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("factors5");
          }
        },
        "factors5": {
          _onEnter: function() {
            this.message = 
              "\n" +
              "     9. METHOD OF THRESHING.\n" +
              "  WITH INCREASED YIELDS MANY FARMERS ARE HIRING CUSTOM MACHINE\n" +
              "  THRESHING RATHER THAN STICKING WITH THE OLD HAND METHOD.\n" +
              "\n" +
              "     10. MARKET VALUE OF ROUGH RICE.\n" +
              "  VARIES WITH VARIETY, QUALITY AND SEASON. AVERAGES (1994)\n" +
              "  ABOUT 312 PESOS PER CAVAN (6.25 PESOS PER KG.)\n" +
              "  MILLING RATE IS ROUGHLY 64% (50 KG. OF PALAY YIELDS\n" +
              "  32 KG. OF RICE).  RETAIL PRICE OF RICE AVERAGED\n" +
              "  (1994) 10.75 PESOS PER KG.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("mainIntro");
          }
        },
        "mainIntro": {
          _onEnter: function() {
            this.message = 
              "\n\n" +
              "    FOR YOUR FIRST CROP YOU MUST MAKE ALL THE DECISIONS BASED\n" +
              "    ON THE INFORMATION GIVEN IN THE INITIAL INTRODUCTION\n" +
              "    AND INSTRUCTIONS.\n" +

              "\n" +
              "    This is the WET season and you have IRRIGATION.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("setFarmSize");
          }
        },
        "setFarmSize": {
          _onEnter: function() {
            if (!this.errorFlag) {
              this.message = "\nWhat is the size of your farm (IN HECTARES)?\n"
            }
          },
          "input": function(line) {
            this.data.farmSize = this.getNumber(this.data.farmSize, line);
            if (!this.errorFlag) {
              if (this.data.farmSize >= 5) {
                this.message = "THAT'S PRETTY LARGE FOR A PEASANT IN LUZON.";
              } else {
                this.message = "";
              }
              this.transition("setWages");
            }
          }
        },
        setWages: {
          _onEnter: function() {
            this.message += "\nWHAT IS THE COST OF OUTSIDE LABOR IN PESOS PER DAY?\n"
          },
          "input": function(line) {
            this.data.wages = this.getNumber(this.data.wages, line);
            if (!this.errorFlag) {
              if (this.data.wages <= 100) {
                this.message = "Those are terrible wages - you cheapskate!!!\n"
              } else if (this.data.wages > 139) {
                this.message = "Very high wages - I doubt you can afford them\n"
              } else {
                this.message = "";
              }
              this.transition("setSeedType");
            }
          }
        },
        setSeedType: {
          _onEnter: function() {
            this.message += "\nIS 'LOCAL' OR 'IR64' RICE TO BE PLANTED?\n"
          },
          "input": function(line) {
            this.data.seedType = this.getResponse("LOCAL,IR64", this.data.seedType, line);
            if (!this.errorFlag) {
              this.transition("setSeedCost");
            }
          }
        },
        setSeedCost: {
          _onEnter: function() {
            this.message = "\nWHAT IS THE COST OF SEED IN PESOS/HA?\n"
          },
          "input": function(line) {
            this.data.costs.seeds = this.getNumber(this.data.seedCost, line);
            if (!this.errorFlag) {
              if (this.data.costs.seeds > 680) {
                this.message = "expensive seed - it may not be good - too old\n"
                this.data.seedDefectFactor = 0.9
              } else if (this.data.costs.seeds <= 560) {
                this.message = "cheap seed - why waste time with it - poor germination\n"
                this.data.seedDefectFactor = 0.9
              } else {
                this.message = "";
              }
              this.transition("setPesticide");
            }
          }
        },
        setPesticide: {
          _onEnter: function() {
            this.message += "\nDO YOU WISH TO APPLY SYSTEMIC PESTICIDE? 'YES' OR 'NO'\n"
          },
          "input": function(line) {
            var response = this.getYesNo(line);
            if (!this.errorFlag) {
              if (response) {
                this.pesticideYieldFactor = 1.15;
                this.data.costs.early_pest_control = 390;
                this.data.hours.early_pest_control = 1.5 * 8;
                this.transition("setFertilizer");
              } else {
                this.transition("setIPM");
              }
            } 
          },
        },
        setIPM: {
          _onEnter: function() {
            this.message = "\nDO YOU WISH TO USE I.P.M.? 'YES' OR 'NO'\n"
          },
          "input": function(line) {
            var response = this.getYesNo(line);
            if (!this.errorFlag) {
              if (response) {
                this.pesticideYieldFactor = 1.15;
                this.data.costs.early_pest_control = 390;
                this.data.hours.early_pest_control = 1.5 * 8;
              } else {
                this.pesticideYieldFactor = 1;
              }
              this.transition("setFertilizer");
            } 
          }
        },
        setFertilizer: {
          _onEnter: function() {
            this.message = 
              "\nFOR NITROGEN FERTILIZER (UREA):" +
              "\n     1. WHAT IS YOUR RATE OF APPLICATION? (KG./HA.)\n";
          },
          "input": function(line) {
            this.data.fertApplRate = this.getNumber(this.data.fertApplRate, line);
            if (!this.errorFlag) {
              if (this.data.fertApplRate <= 0) {
                this.data.fertApplRate = 0;
                this.transition("setLandPrep");
              } else {
                if (this.data.fertApplRate > 400) {
                  this.message = 
                    ("" + this.data.fertApplRate) +
                    " KG. OF UREA CONTAINS "+ 
                    this.data.fertNContent() +" KG. OF NITROGEN.\n" +
                    "YOUR CROP CAN NOT USE THAT MUCH.  YOU MAY CAUSE SOME\n" +
                    "DAMAGE TO THE ECOSYSTEMS IN NEARBY STREAMS.  AT THE\n" +
                    "VERY LEAST, YOU HAVE WASTED MANY PESOS.\n" +
                    "\n";
                }
                this.transition("setFertilizer2");
              }
            }
          }
        },
        setFertilizer2: {
          _onEnter: function() {
            this.message = "\n     2. WHAT IS THE COST OF UREA (PESOS/KG.)\n"
          },
          "input": function(line){
            this.data.fertCost = this.getNumber(this.data.fertCost, line);
            if (!this.errorFlag) {
              if (this.data.fertCost <= 6.8) {
                this.message = "You can not buy it so CHEAPLY - PLEASE REPEAT";
              } else if (this.data.fertCost > 7.4) {
                this.message = "THAT IS EXPENSIVE FERTILIZER - PLEASE REPEAT";
              } else {
                this.transition("setLandPrep");
              }
            }
          }
        },
        setLandPrep: {
          _onEnter: function() {
            this.message = "\n" +
              "do you plan to use 'CARABAO' (WATER BUFFALO) or 'TRACTOR'\n" +
              "for cropland preparation\n";
          },
          "input": function(line){
            this.data.prepMethod = this.getResponse("CARABAO,TRACTOR", this.data.prepMethod, line);
            if (!this.errorFlag) {
              if (this.data.prepMethod === "CARABAO") {
                this.transition("setCarabaoOwnership");
              } else {
                this.data.ownOrHire = "HIRE";
                this.message = 
                  "THE CURRENT RATE FOR HIRED TRACTOR PLUS DRIVER IS\n" + 
                  this.TRACTOR_RATE + " PESOS/HOUR.\n";
                this.transition("setWeeding");
              }
            }
          }
        },
        setCarabaoOwnership: {
          _onEnter: function() {
            this.message = "\ndo you 'OWN' or will you 'HIRE' the carabao\n";
          },
          "input": function(line){
            this.data.ownOrHire = this.getResponse("OWN,HIRE", this.data.ownOrHire, line);
            if (!this.errorFlag) {
              if (this.data.ownOrHire === "HIRE") {
                this.message = 
                  "THE CURRENT RATE FOR CARABAO PLUS HANDLER IS " + 
                  this.CARABAO_RATE + " PESOS/\n" +
                  "HOUR.\n";
              }
              this.transition("setWeeding");
            }
          }
        },
        setWeeding: {
          _onEnter: function() {
            this.message +=
              "\n" +
              "There are three weeding methods available\n" +
              "     1. HAND WEEDING.\n" +
              "     2. ROTARY HAND WEEDER.\n" +
              "     3. GRANULAR HERBICIDE (2,4-D ISOPROPYL ESTER)\n" +
              "\n" +
              "THESE METHODS MAY BE EMPLOYED EITHER SINGLY OR IN\n" +
              "COMBINATION WITH ONE OTHER METHOD. WHEN REQUESTED,\n" +
              "ENTER NUMBERS CORRESPONDING TO THE METHODS ABOVE,\n" +
              "FOR INSTANCE '2' MEANS ONE ROTARY WEEDING, '32' MEANS\n" +
              "2,4-D FOLLOWED BY A ROTARY WEEDING, AND '11' MEANS\n" +
              "2 HAND WEEDINGS.\n" +
              this.waitText;
          },
          "input": function(line) {
            this.transition("setWeeding2");
          }
        },
        setWeeding2: {
          _onEnter: function() {
            this.message =
            "\nPlease note the following:\n" +
            "   A. WEEDS COMPETE VIGOROUSLY WITH RICE AND LOWER\n" +
            "      THE POTENTIAL YIELD.\n" +
            "   B. WHEN A HAND WEEDING IS DONE IN COMBINATION WITH\n" +
            "      ANOTHER METHOD, THE HAND WEEDING IS USUALLY DONE\n" +
            "      LAST (I.E. '31', NOT '13'!)\n" +
            "   C. if YOU DESIRE NO WEEDING, ENTER 0 (ZERO).\n" +
            "\n" +
            "What weeding method(s) do you wish to use\n";
          },
          "input": function(line) {
            this.data.weedingMethod = this.getResponse(this.data.VALID_WEEDING, this.data.weedingMethod, line);
            if (!this.errorFlag) {
              this.transition("setMolluscicide");
            }
          }
        },
        setMolluscicide: {
          _onEnter: function() {
            this.snailAttacks++;
            this.message =
              "\n" +
              "Oh my goodness! DURING THE WEED SURVEY MANY BRIGHT RED EGG\n" +
              "MASSES OF THE GOLDEN SNAIL WERE SEEN IN YOUR FIELDS. If you wish\n" +
              "you may spray MOLLUSCICIDE or remove the snails and eggs by\n" +
              "hand. You may also choose to do nothing.\n" +
              "\n" +
              "DO YOU WISH TO SPRAY A MOLLUSCICIDE?\n";
          },
          "input": function(line) {
            var response = this.getYesNo(line);
            if (!this.errorFlag) {
              if (response) {
                this.snailAttacks = 0;
                this.data.costs.molluscicide = 315;
                this.data.hours.molluscicide = 18;
                this.transition("setWeedingStart");
              } else {
                this.transition("setHandPickSnails");
              }
            } 
          }
        },
        setHandPickSnails: {
          _onEnter: function() {
            this.snailAttacks++;
            this.message = "\nDO YOU WISH TO HAND PICK YOUR FIELDS?\n";
          },
          "input": function(line) {
            var response = this.getYesNo(line);
            if (!this.errorFlag) {
              if (response) {
                this.snailAttacks = 0;
                this.data.costs.molluscicide = 0;
                this.data.hours.molluscicide = 60;
              }
              this.transition("setWeedingStart");
            } 
          } 
        },
        setWeedingStart: {
          _onEnter: function() {
            this.message = "\n" +
              "HOW MANY DAYS AFTER TRANSPLANTING IS THE WEEDING\n" +
              "OPERATION STARTED\n";
          },
          "input": function(line) {
            this.weedingDaysStart = this.getNumber(this.weedingDaysStart, line);
            if (!this.errorFlag) {
              this.transition("setThreshing");
            }
          }
        },
        setThreshing: {
          _onEnter: function() {
            this.message = "\nIs the threshing to be done by 'HAND' or by 'MACHINE'\n";
          },
          "input": function(line){
            this.data.threshingMethod = this.getResponse("HAND,MACHINE", this.data.threshingMethod, line);
            if (!this.errorFlag) {
              this.transition("setMarketValue");
            }
          }
        },
        setMarketValue: {
          _onEnter: function() {
            this.message = "\n" +
              "What is the market value of ROUGH RICE (PESOS/KG.)\n";
          },
          "input": function(line) {
            this.data.price = this.getNumber(this.data.price, line);
            if (!this.errorFlag) {
              if (this.data.price > 6.35) {
                this.message = 
                "\nTHAT'S WAY ABOVE THE LATEST REPORTED MARKET PRICE.\n" +
                "PLEASE REPEAT THE PRICE PER KILOGRAM.\n";
              } else {
                this.transition("startProcessing");
              }
            }
          }
        }
      },

      // Other utility functions
      //
      waitText: "\nPress Enter to continue...\n",
      getYesNo: function(line) {
        this.errorFlag = false;
        var response = line.trim().toUpperCase();
        if (response === "YES" || response === "Y" || response === "NO" || response === "N") {
          return (response === "YES" || response == "Y");
        } else {
          this.errorFlag = true;
          this.message = "Please enter 'YES' or 'NO'";
        }
      },
      getNumber: function(original, line) {
        this.sameFlag = false;
        this.errorFlag = false;
        var response = line.trim().toUpperCase();
        if (response === "SAME") {
          if (original !== null) {
            this.sameFlag = true;
            return original;
          } else {
            this.message = "You cannot use the same value" 
            this.errorFlag = true;
          }
        } else {
          if (!isNaN(parseFloat(response))) {
            return parseFloat(response);
          } else {
            this.message = "Please type a number" 
            this.errorFlag = true;
          }
        }
      },
      getResponse: function(valid, original, line) {
        this.sameFlag = false;
        this.errorFlag = false;
        var response = line.trim().toUpperCase();
        if (response === "SAME") {
          if (original !== null) {
            this.sameFlag = true;
            return original;
          } else {
            this.message = "You cannot use the same value" 
            this.errorFlag = true;
          }
        } else {
          if (_.contains(valid.split(","), response)) {
            return response;
          } else {
            this.message = "That is not a legal response. Please retype." 
            this.errorFlag = true;
          }
        }
      }
    });
    var console1 = $("#console1");
    var controller1 = console1.console({
      promptLabel: '> ',
      commandHandle:function(line){
         gameFsm.handle("input", line);
         return gameFsm.message;
      },
      autofocus:true,
      animateScroll:true,
      welcomeMessage: "    ARE YOU FAMILIAR ENOUGH WITH THE PROGRAM TO WISH TO SKIP\n    ALL PRELIMINARIES? "
    });
  });
})(jQuery, _);
