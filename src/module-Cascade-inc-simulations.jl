
    # Functions and methods for cascade simulations

    """
    `Cascade.addLevels(levelsA::Array{Cascade.Level,1}, levelsB::Array{Cascade.Level,1})` 
        ... adds two sets of levels so that each levels occurs only 'once' in the list; however, this addition requires also that the
            parent and daughter processes are added properly so that all information is later available for the simulations.
            It is assumed that all daugther and parent (processes) appear only once if levels from different data sets
            (Cascade.DecayData, Cascade.PhotoIonData) are added to each other.
            A message is issued about the number of levels before and after this 'addition', and how many levels have been modified.
            Note that all relative occucations are set to zero in this addition; a newlevels::Array{Cascade.Level,1} is returned.
    """
    function  addLevels(levelsA::Array{Cascade.Level,1}, levelsB::Array{Cascade.Level,1})
        nA = length(levelsA);   nB = length(levelsB);    nmod = 0;    nnew = 0;    newlevels = Cascade.Level[];  appendedB = falses(nB)
        
        # First all levels from levels A but taking additional parents and daugthers into accout
        for  levA in levelsA
            parents   = deepcopy(levA.parents);     daugthers = deepcopy(levA.daugthers);   
            for  (i,levB) in enumerate(levelsB)
                if levA == levB     appendedB[i] = true
                    for p in levB.parents     push!(parents,   p)   end
                    for d in levB.daugthers   push!(daugthers, d)   end
                    if  length(parents) > length(levA.parents)  ||  length(daugthers) > length(levA.daugthers)  nmod = nmod + 1   end
                    break
                end
            end
            push!(newlevels, Cascade.Level(levA.energy, levA.J, levA.parity, levA.NoElectrons, 0., parents, daugthers) )
        end
        
        # Append those levels from levelsB that are not yet appended
        for  (i,levB) in enumerate(levelsB)
            if appendedB[i]
            else    push!(newlevels, levB);     nnew = nnew + 1
            end 
        end
        nN = length(newlevels)
        println("> Append $nnew (new) levels to $nA levels results in a total of $nN levels (with $nmod modified levels) in the list.")
        return( newlevels )
    end


    #===
    """
    `Cascade.appendLevels!(allLevels::Array{Cascade.Level,1}, levels::Array{Cascade.Level,1})` 
        ... appends the (cascade) levels to allLevels if they do not yet occur in the list; a message is issued about the number
            of levels before and after this 'addition'. The argument allLevels is modified but nothing (else) is returned.
    """
    function  appendLevels!(allLevels::Array{Cascade.Level,1}, levels::Array{Cascade.Level,1})
        naBefore = length(allLevels);   nlev = length(levels)
        for  level in levels
            append = true
            for allLevel in allLevels   if  level == allLevel   append = false;     break   end     end
            if  append   push!(allLevels, level)    end
        end
        naAfter = length(allLevels)
        println("> Append $nlev (new) levels to $naBefore levels results in a total of $naAfter levels in the list.")
        return( nothing )
    end
    ==#
    
    
    """
    `Cascade.displayIonDistribution(stream::IO, sc::String, levels::Array{Cascade.Level,1})` 
        ... displays the (current or final) ion distribution in a neat table. Nothing is returned.
    """
    function displayIonDistribution(stream::IO, sc::String, levels::Array{Cascade.Level,1})
        minElectrons = 1000;   maxElectrons = 0
        for  level in levels   minElectrons = min(minElectrons, level.NoElectrons);   maxElectrons = max(maxElectrons, level.NoElectrons)   end
        println(stream, " ")
        println(stream, "  (Final) Ion distribution for the cascade:  $sc ")
        println(stream, " ")
        println(stream, "  ", TableStrings.hLine(31))
        sa = "  "
        sa = sa * TableStrings.center(14, "No. electrons"; na=4)        
        sa = sa * TableStrings.center(10,"Rel. occ.";      na=2)
        println(stream, sa)
        println(stream, "  ", TableStrings.hLine(31))
        for n = maxElectrons:-1:minElectrons
            sa = "             " * string(n);   sa = sa[end-10:end];   prob = 0.
            for  level in levels    if  n == level.NoElectrons   prob = prob + level.relativeOcc    end    end
            sa = sa * "         " * @sprintf("%.5e", prob)
            println(stream, sa)
        end
        println(stream, "  ", TableStrings.hLine(31))

        return( nothing )
    end


    """
    `Cascade.displayLevelDistribution(stream::IO, sc::String, levels::Array{Cascade.Level,1})` 
        ... displays the (current or final) level distribution in a neat table. Only those levels with a non-zero 
            occupation are displayed here. Nothing is returned.
    """
    function displayLevelDistribution(stream::IO, sc::String, levels::Array{Cascade.Level,1})
        minElectrons = 1000;   maxElectrons = 0;   energies = zeros(length(levels))
        for  i = 1:length(levels)
            minElectrons = min(minElectrons, levels[i].NoElectrons);   maxElectrons = max(maxElectrons, levels[i].NoElectrons)
            energies[i]  = levels[i].energy   
        end
        enIndices = sortperm(energies, rev=true)
        # Now printout the results
        println(stream, " ")
        println(stream, "  (Final) Level distribution for the cascade:  $sc")
        println(stream, " ")
        println(stream, "  ", TableStrings.hLine(69))
        sa = "  "
        sa = sa * TableStrings.center(14, "No. electrons"; na=2)        
        sa = sa * TableStrings.center( 8, "Lev-No"; na=2)        
        sa = sa * TableStrings.center( 6, "J^P"          ; na=3);               
        sa = sa * TableStrings.center(16, "Energy " * TableStrings.inUnits("energy"); na=5)
        sa = sa * TableStrings.center(10, "Rel. occ.";                                    na=2)
        println(stream, sa)
        println(stream, "  ", TableStrings.hLine(69))
        for n = maxElectrons:-1:minElectrons
            sa = "            " * string(n);        sa  = sa[end-10:end]
            for  en in enIndices
                saa = "            " * string(en);  saa = saa[end-12:end]
                if  n == levels[en].NoElectrons  ##    &&  levels[en].relativeOcc > 0
                    sx = "    " * string( LevelSymmetry(levels[en].J, levels[en].parity) )                       * "           "
                    sb = sa * saa * sx[1:15]
                    sb = sb * @sprintf("%.6e", Defaults.convertUnits("energy: from atomic", levels[en].energy))  * "      "
                    sb = sb * @sprintf("%.5e", levels[en].relativeOcc) 
                    sa = "           "
                    println(stream, sb)
                end
            end
        end
        println(stream, "  ", TableStrings.hLine(69))

        return( nothing )
    end


    """
    `Cascade.displayLevelTree(stream::IO, levels::Array{Cascade.Level,1}; extended::Bool=false)` 
        ... displays all defined levels  in a neat table, together with their No. of electrons, symmetry, level energy, 
            current (relative) population as well as analogue information about their parents and daugther levels. This 
            enables one to recognize (and perhaps later add) missing parent and daughter levels. Nothing is returned.
    """
    function displayLevelTree(stream::IO, levels::Array{Cascade.Level,1}; extended::Bool=false)
        minElectrons = 1000;   maxElectrons = 0;   energies = zeros(length(levels))
        for  i = 1:length(levels)
            minElectrons = min(minElectrons, levels[i].NoElectrons);   maxElectrons = max(maxElectrons, levels[i].NoElectrons)
            energies[i]  = levels[i].energy   
        end
        enIndices = sortperm(energies, rev=true)
        # Now printout the results
        println(stream, " ")
        println(stream, "* Level tree of this cascade:  **name ?? **")
        println(stream, " ")
        if  extended    println(stream, "  ", TableStrings.hLine(179))  else    println(stream, "  ", TableStrings.hLine(65))  end
        sa = " "
        sa = sa * TableStrings.center( 6, "No. e-"; na=2)        
        sa = sa * TableStrings.center( 6, "Lev-No"; na=2)        
        sa = sa * TableStrings.center( 6, "J^P"          ; na=2);               
        sa = sa * TableStrings.center(16, "Energy " * TableStrings.inUnits("energy"); na=2)
        sa = sa * TableStrings.center(10, "Rel. occ.";                                na=3)
        if  extended
            sb = "Parents P(A/R: No_e, sym, energy) and Daughters D(A/R: No_e, sym, energy);  all energies in " * TableStrings.inUnits("energy")
            sa = sa * TableStrings.flushleft(100, sb; na=2)
        end
        # 
        println(stream, sa)
        if  extended    println(stream, "  ", TableStrings.hLine(179))  else    println(stream, "  ", TableStrings.hLine(65))  end
        for n = maxElectrons:-1:minElectrons
            sa = "            " * string(n);     sa  = sa[end-5:end]
            for  en in enIndices
                saa = "         " * string(en);  saa = saa[end-8:end]
                if  n == levels[en].NoElectrons
                    sx = "    " * string( LevelSymmetry(levels[en].J, levels[en].parity) )                       * "           "
                    sb = sa * saa * sx[1:15]
                    sb = sb * @sprintf("%.5e", Defaults.convertUnits("energy: from atomic", levels[en].energy))  * "    "
                    sb = sb * @sprintf("%.4e", levels[en].relativeOcc)                                           * "  "
                    if extended
                    pProcessSymmetryEnergyList = Tuple{AtomicProcess,Int64,LevelSymmetry,Float64}[]
                    dProcessSymmetryEnergyList = Tuple{Basics.AtomicProcess,Int64,LevelSymmetry,Float64}[]
                    for  p in levels[en].parents
                        idx = p.index
                        if      p.process == Basics.Auger         lev = p.lineSet.linesA[idx].initialLevel
                        elseif  p.process == Basics.Radiative     lev = p.lineSet.linesR[idx].initialLevel
                        elseif  p.process == Basics.Photo         lev = p.lineSet.linesP[idx].initialLevel
                        else    error("stop a")    end
                        push!( pProcessSymmetryEnergyList, (p.process, lev.basis.NoElectrons, LevelSymmetry(lev.J, lev.parity), lev.energy) )
                    end
                    for  d in levels[en].daugthers
                        idx = d.index
                        if      d.process == Basics.Auger         lev = d.lineSet.linesA[idx].finalLevel
                        elseif  d.process == Basics.Radiative     lev = d.lineSet.linesR[idx].finalLevel
                        elseif  d.process == Basics.Photo         lev = d.lineSet.linesP[idx].finalLevel
                        else    error("stop b")    end
                        push!( dProcessSymmetryEnergyList, (d.process, lev.basis.NoElectrons, LevelSymmetry(lev.J, lev.parity), lev.energy) )
                    end
                    wa = TableStrings.processSymmetryEnergyTupels(120, pProcessSymmetryEnergyList, "P")
                    if  length(wa) > 0    sc = sb * wa[1];    println(stream,  sc )    else    println(stream,  sb )   end  
                    for  i = 2:length(wa)
                        sc = TableStrings.hBlank( length(sb) ) * wa[i];    println(stream,  sc )
                    end
                    wa = TableStrings.processSymmetryEnergyTupels(120, dProcessSymmetryEnergyList, "D")
                    for  i = 1:length(wa)
                        sc = TableStrings.hBlank( length(sb) ) * wa[i];    println(stream,  sc )
                    end
                    else    println(stream,  sb )
                    end  ## extended
                    sa = "      "
                end
            end
        end
        if  extended    println(stream, "  ", TableStrings.hLine(179))  else    println(stream, "  ", TableStrings.hLine(65))  end

        return( nothing )
    end


    """
    `Cascade.extractLevels(data::Cascade.DecayData, settings::Cascade.SimulationSettings)` 
        ... extracts and sorts all levels from the given cascade data into a new levelList::Array{Cascade.Level,1} to simplify the 
            propagation of the probabilities. In this list, every level of the overall cascade just occurs just once, together 
            with its parent lines (which may populate the level) and the daugther lines (to which the pobability may decay). 
            A levelList::Array{Cascade.Level,1} is returned.
    """
    function extractLevels(data::Cascade.DecayData, settings::Cascade.SimulationSettings)
        printSummary, iostream = Defaults.getDefaults("summary flag/stream")
        levels = Cascade.Level[]
        print("> Extract and sort the list of levels for the given decay data ... ")
        if printSummary     print(iostream, "> Extract and sort the list of levels for the given decay data ... ")     end
        
        for  i = 1:length(data.linesR)
            line = data.linesR[i]
            iLevel = Cascade.Level( line.initialLevel.energy, line.initialLevel.J, line.initialLevel.parity, line.initialLevel.basis.NoElectrons,
                                    line.initialLevel.relativeOcc, Cascade.LineIndex[], [ Cascade.LineIndex(data, Basics.Radiative, i)] ) 
            Cascade.pushLevels!(levels, iLevel)  
            fLevel = Cascade.Level( line.finalLevel.energy, line.finalLevel.J, line.finalLevel.parity, line.finalLevel.basis.NoElectrons,
                                    line.finalLevel.relativeOcc, [ Cascade.LineIndex(data, Basics.Radiative, i)], Cascade.LineIndex[] ) 
            Cascade.pushLevels!(levels, fLevel)  
        end

        for  i = 1:length(data.linesA)
            line = data.linesA[i]
            iLevel = Cascade.Level( line.initialLevel.energy, line.initialLevel.J, line.initialLevel.parity, line.initialLevel.basis.NoElectrons,
                                    line.initialLevel.relativeOcc, Cascade.LineIndex[], [ Cascade.LineIndex(data, Basics.Auger, i)] ) 
            Cascade.pushLevels!(levels, iLevel)  
            fLevel = Cascade.Level( line.finalLevel.energy, line.finalLevel.J, line.finalLevel.parity, line.finalLevel.basis.NoElectrons,
                                    line.finalLevel.relativeOcc, [ Cascade.LineIndex(data, Basics.Auger, i)], Cascade.LineIndex[] ) 
            Cascade.pushLevels!(levels, fLevel)  
        end
        
        # Sort the levels by energy in reversed order
        energies  = zeros(length(levels));       for  i = 1:length(levels)   energies[i]  = levels[i].energy   end
        enIndices = sortperm(energies, rev=true)
        newlevels = Cascade.Level[]
        for i = 1:length(enIndices)   ix = enIndices[i];    push!(newlevels, levels[ix])    end
        
        println("a total of $(length(newlevels)) levels were found.")
        if printSummary     println(iostream, "a total of $(length(newlevels)) levels were found.")     end
        
        return( newlevels )
    end


    """
    `Cascade.extractLevels(data::Array{Cascade.PhotoIonData,1}, settings::Cascade.SimulationSettings)` 
        ... extracts and sorts all levels from the given cascade data into a new levelList::Array{Cascade.Level,1} to simplify the 
            propagation of the probabilities. In this list, every level of the overall cascade just occurs just once, together 
            with its parent lines (which may populate the level) and the daugther lines (to which the pobability may decay). 
            A levelList::Array{Cascade.Level,1} is returned.
    """
    function extractLevels(data::Array{Cascade.PhotoIonData,1}, settings::Cascade.SimulationSettings)
        printSummary, iostream = Defaults.getDefaults("summary flag/stream");   found = false
        photonEnergy = settings.initialPhotonEnergy;   newlevels = Cascade.Level[]
        for dataset in data
            @show dataset.photonEnergy
            if  dataset.photonEnergy == photonEnergy       found     = true
                newlevels = Cascade.extractLevels(dataset, settings);    break
            end
        end
        
        if  !found  error("No proper photo-ionizing data set (Cascade.PhotoIonData) found for the photon energy $photonEnergy ")  end
        return( newlevels )
    end


    """
    `Cascade.extractLevels(data::Cascade.PhotoIonData, settings::Cascade.SimulationSettings)` 
        ... extracts and sorts all levels from the given cascade data into a new levelList::Array{Cascade.Level,1} to simplify the 
            propagation of the probabilities. In this list, every level of the overall cascade just occurs just once, together 
            with its parent lines (which may populate the level) and the daugther lines (to which the pobability may decay). 
            A levelList::Array{Cascade.Level,1} is returned.
    """
    function extractLevels(data::Cascade.PhotoIonData, settings::Cascade.SimulationSettings)
        printSummary, iostream = Defaults.getDefaults("summary flag/stream")
        levels = Cascade.Level[]
        print("> Extract and sort the list of levels for the given photo-ionization data ... ")
        if printSummary     print(iostream, "> Extract and sort the list of levels for the given photo-ionization data ... ")     end

        for  i = 1:length(data.linesP)
            line = data.linesP[i]
            iLevel = Cascade.Level( line.initialLevel.energy, line.initialLevel.J, line.initialLevel.parity, line.initialLevel.basis.NoElectrons,
                                    line.initialLevel.relativeOcc, Cascade.LineIndex[], [ Cascade.LineIndex(data, Basics.Photo, i)] ) 
            Cascade.pushLevels!(levels, iLevel)  
            fLevel = Cascade.Level( line.finalLevel.energy, line.finalLevel.J, line.finalLevel.parity, line.finalLevel.basis.NoElectrons,
                                    line.finalLevel.relativeOcc, [ Cascade.LineIndex(data, Basics.Photo, i)], Cascade.LineIndex[] ) 
            Cascade.pushLevels!(levels, fLevel)  
        end
        
        # Sort the levels by energy in reversed order
        energies  = zeros(length(levels));       for  i = 1:length(levels)   energies[i]  = levels[i].energy   end
        enIndices = sortperm(energies, rev=true)
        newlevels = Cascade.Level[]
        for i = 1:length(enIndices)   ix = enIndices[i];    push!(newlevels, levels[ix])    end
        
        println("a total of $(length(newlevels)) levels were found.")
        if printSummary     println(iostream, "a total of $(length(newlevels)) levels were found.")     end
        
        return( newlevels )
    end


    """
    `Cascade.findLevelIndex(level::Cascade.Level, levels::Array{Cascade.Level,1})` 
        ... find the index of the given level within the given list of levels; an idx::Int64 is returned and an error message is 
            issued if the level is not found in the list.
    """
    function findLevelIndex(level::Cascade.Level, levels::Array{Cascade.Level,1})
        for  k = 1:length(levels)
            if  level.energy == levels[k].energy  &&   level.J == levels[k].J   &&   level.parity == levels[k].parity   &&
                level.NoElectrons == levels[k].NoElectrons
                kk = k;   return( kk )
            end
        end
        error("findLevelIndex():  No index was found;\n   level = $(level) ")
    end



    """
    `Cascade.perform(simulation::Cascade.Simulation`  
        ... to simulate a cascade decay (and excitation) from the given data. Different computational methods and different properties of 
            the ionic system, such as the ion distribution or final-level distribution can be derived and displayed from these simulations. 
            Of course, the details of these simulations strongly depend on the atomic processes and data that have been generated before by 
            performing a computation::Cascade.Computation. The results of all individual steps are printed to screen but nothing is 
            returned otherwise.

    `Cascade.perform(simulation::Cascade.Simulation; output=true)`   
        ... to perform the same but to return the complete output in a dictionary; the particular output depends on the method and 
            specifications of the cascade but can easily accessed by the keys of this dictionary.
    """
    function perform(simulation::Cascade.Simulation; output::Bool=false)
        if  output    results = Dict{String, Any}()    else    results = nothing    end
        
        # First review and display the computation data for this simulation; this enables the reader to check the consistency of data.
        # It also returns the level tree to be used in the simulations
        levels = Cascade.reviewData(simulation)
        
        # Distinguish between the different computational methods for running the simulations
        if  simulation.method == Cascade.ProbPropagation()
            if  Cascade.FinalLevelDistribution()  in  simulation.properties   ||   Cascade.IonDistribution()  in  simulation.properties
                wa = Cascade.simulateLevelDistribution(levels, simulation) 
            end
            if  Cascade.ElectronIntensities()  in simulation.properties    ||   Cascade.PhotonIntensities()  in simulation.properties   ||
                Cascade.ElectronCoincidence()  in simulation.properties 
                error("stop a: Not yet implemented")    
            end
        else  error("stop b")
        end

        if output 
            wx = 0.   
            results = Base.merge( results, Dict("ion distribution:" => wx) )
            #  Write out the result to file to later continue with simulations on the cascade data
            filename = "zzz-Cascade-simulation-" * string(now())[1:13] * ".jld"
            println("\nWrite all results to disk; use:\n   save($filename, results) \n   using JLD " *
                    "\n   results = load($filename)    ... to load the results back from file ... CURRENTLY NOT.")
            ## save(filename, results)
        end
        return( results )
    end


    """
    `Cascade.propagateProbability!(levels::Array{Cascade.Level,1})` 
        ... propagates the relative level occupation through the levels of the cascade until no further change occur in the 
            relative level occupation. The argument levels is modified during the propagation, but nothing is returned otherwise.
    """
    function propagateProbability!(levels::Array{Cascade.Level,1})
        n = 0
        println("\n*  Probability propagation through $(length(levels)) levels of the cascade:")
        while true
            n = n + 1;    totalProbability = 0.
            print("    $n-th round ... ")
            for  level in levels
                if   level.relativeOcc > 0.   && length(level.daugthers) > 0
                    # A level with relative occupation > 0 has still 'daugther' levels; collect all excitation/decay rates for this level
                    # Here, an excitation cross section is formally treated as a rate as it is assumed that the initial levels of
                    # the photoionization process cannot decay by photon emission or autoionization processes.
                    prob  = level.relativeOcc;   totalProbability = totalProbability + prob;   rates = zeros(length(level.daugthers))
                    level.relativeOcc = 0.
                    for  (i,daugther) in  enumerate(level.daugthers)
                        idx = daugther.index
                        if      daugther.process == Basics.Radiative     rates[i] = daugther.lineSet.linesR[idx].photonRate.Babushkin
                        elseif  daugther.process == Basics.Auger         rates[i] = daugther.lineSet.linesA[idx].totalRate
                        elseif  daugther.process == Basics.Photo         rates[i] = daugther.lineSet.linesP[idx].crossSection.Coulomb
                                ##x println("Cou = $(daugther.lineSet.linesP[idx].crossSection.Coulomb),  Bab = $(daugther.lineSet.linesP[idx].crossSection.Babushkin)" )
                                ##x println("photon energy = $(daugther.lineSet.linesP[idx].photonEnergy)")
                        else    error("stop a; process = $(daugther.process) ")
                        end
                    end
                    totalRate = sum(rates)
                    # Shift the relative occupation to the 'daugther' levels due to the different ionization and decay pathes
                    for  (i,daugther) in  enumerate(level.daugthers)
                        idx = daugther.index
                        if      daugther.process == Basics.Radiative     line = daugther.lineSet.linesR[idx]
                        elseif  daugther.process == Basics.Auger         line = daugther.lineSet.linesA[idx]
                        elseif  daugther.process == Basics.Photo         line = daugther.lineSet.linesP[idx]
                        else    error("stop b; process = $(daugther.process) ")
                        end
                        newLevel = Cascade.Level( line.finalLevel.energy, line.finalLevel.J, line.finalLevel.parity, 
                                                  line.finalLevel.basis.NoElectrons, 0., Cascade.LineIndex[], Cascade.LineIndex[] )
                        kk    = Cascade.findLevelIndex(newLevel, levels)
                        levels[kk].relativeOcc = levels[kk].relativeOcc + prob * rates[i] / totalRate
                    end
                end
            end
            println("has propagated a total of $totalProbability level occupation.")
            # Cycle once more if the relative occupation has still changed
            if  totalProbability == 0.    break    end
        end

        return( nothing )
    end


    """
    `Cascade.pushLevels!(levels::Array{Cascade.Level,1}, newLevel::Cascade.Level)` 
        ... push's the information of newLevel of levels. This is the standard 'push!(levels, newLevel)' if newLevel is not yet 
            including in levels, and the proper modification of the parent and daugther lines of this level otherwise. The argument 
            levels::Array{Cascade.Level,1} is modified and nothing is returned otherwise.
    """
    function pushLevels!(levels::Array{Cascade.Level,1}, newLevel::Cascade.Level)
        for  i = 1:length(levels)
            if  newLevel.energy == levels[i].energy  &&  newLevel.J == levels[i].J  &&  newLevel.parity == levels[i].parity
                append!(levels[i].parents,   newLevel.parents)
                append!(levels[i].daugthers, newLevel.daugthers)
                return( nothing )
            end
        end
        push!( levels, newLevel)
        ##x info("... one level added, n = $(length(levels)) ")
        return( nothing )
    end


    """
    `Cascade.reviewData(simulation::Cascade.Simulation)` 
        ... reviews and displays the (computation) data for the given simulation; these data contains the name of the data set, 
            its initial and generated multiplets for the various blocks of (some part of the ionization and/or decay) cascade as 
            well as all the line data [lineR, linesA, lineP, ...]. From these data, this function also generates and returns
            the level tree that is to be used in the subsequent simulations.
    """
    function reviewData(simulation::Cascade.Simulation)
        printSummary, iostream = Defaults.getDefaults("summary flag/stream")
        dataDicts = simulation.computationData;     settings = simulation.settings;     allLevels = Cascade.Level[]
        
        # Loop through all (computation) data set and display the major results
        for  (i,data) in  enumerate(dataDicts)
            multiplets  = data["initial multiplets:"]
            gMultiplets = data["generated multiplets:"]
            nlev = 0;    for multiplet in multiplets     nlev  = nlev  + length(multiplet.levels)     end
            nglev = 0;   for multiplet in gMultiplets    nglev = nglev + length(multiplet.levels)     end
            println("\n* $i) Data dictionary for cascade computation:   $(data["name"])  with  $nlev initial and  $nglev generated levels") 
            println(  "  ===========================================")
            
            Cascade.displayLevels(stdout, multiplets, sa="initial ")
            if  printSummary 
                println(iostream, "\n* $i) Data dictionary for cascade computation:   $(data["name"])  with  $nlev initial and  $nglev generated levels") 
                println(iostream,   "  ===========================================")
                Cascade.displayLevels(iostream, multiplets,  sa="initial ")
                Cascade.displayLevels(iostream, gMultiplets, sa="generated ")        
            end
            #
            if      haskey(data,"decay line data:")                lineData = data["decay line data:"]
            elseif  haskey(data,"photo-ionizing line data:")       lineData = data["photo-ionizing line data:"]
            else    error("stop a")
            end
            levels = Cascade.extractLevels(lineData, settings)
            ##x Cascade.appendLevels!(allLevels, levels)
            allLevels = Cascade.addLevels(allLevels, levels)
        end
        
        allLevels = Cascade.sortByEnergy(allLevels, simulation.settings)
        Cascade.displayLevelTree(stdout, allLevels, extended=false)
        
        return( allLevels )
    end
    

    """
    `Cascade.simulateLevelDistribution(levels::Array{Cascade.Level,1}, simulation::Cascade.Simulation)` 
        ... sorts all levels as given by data and propagates their (occupation) probability until no further changes occur. For this 
            propagation, it runs through all levels and propagates the probabilty until no level probability changes anymore. The final 
            level distribution is then used to derive the ion distribution or the level distribution, if appropriate. Nothing is returned.
    """
    function simulateLevelDistribution(levels::Array{Cascade.Level,1}, simulation::Cascade.Simulation)
        printSummary, iostream = Defaults.getDefaults("summary flag/stream")
        #
        ##x Cascade.displayLevelTree(stdout, levels, simulation.cascadeData, extended=false)
        ##x if  printSummary   Cascade.displayLevelTree(iostream, levels, simulation.cascadeData, extended=false)
        ##x                    Cascade.displayLevelTree(iostream, levels, simulation.cascadeData, extended=true)
        ##x end
        Cascade.propagateProbability!(levels)   ##x , simulation.cascadeData)
        #
        if  Cascade.IonDistribution()        in simulation.properties    
            Cascade.displayIonDistribution(stdout, simulation.name, levels)     
            if  printSummary   Cascade.displayIonDistribution(iostream, simulation.name, levels)      end
        end
        if  Cascade.FinalLevelDistribution() in simulation.properties    
            Cascade.displayLevelDistribution(stdout, simulation.name, levels)   
            if  printSummary   Cascade.displayLevelDistribution(iostream, simulation.name, levels)    end
        end

        return( nothing )
    end
    

    """
    `Cascade.sortByEnergy(levels::Array{Cascade.Level,1}, settings::Cascade.SimulationSettings)` 
        ... sorts all levels by energy and assigns the occupation as given by the simulation
    """
    function sortByEnergy(levels::Array{Cascade.Level,1}, settings::Cascade.SimulationSettings)
        printSummary, iostream = Defaults.getDefaults("summary flag/stream")
        newlevels = Cascade.Level[]
        #
        
        # Sort the levels by energy in reversed order
        energies  = zeros(length(levels));       for  i = 1:length(levels)   energies[i]  = levels[i].energy   end
        enIndices = sortperm(energies, rev=true)
        newlevels = Cascade.Level[]
        for i = 1:length(enIndices)   ix = enIndices[i];    push!(newlevels, levels[ix])    end
        
        # Assign the relative occupation of the levels in this list due to the given settings
        for  pair  in  settings.initialOccupations
            newlevels[pair[1]].relativeOcc = pair[2]
        end

        println("> Sort and assign occupation to a total of $(length(newlevels)) levels, and to which all level numbers refer below.")
        println("   Here all charged states are considered together in the overall cascade.")
        if printSummary     
            println(iostream, "> Sort and assign occupation to a total of $(length(newlevels)) levels, and to which all level numbers refer below.")
            println(iostream, "   Here all charged states are considered together in the overall cascade.")
        end

        return( newlevels )
    end
