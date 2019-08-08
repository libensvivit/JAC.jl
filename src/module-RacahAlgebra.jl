
"""
`module JAC.RacahAlgebra`  
    ... a submodel of JAC that contains procedures for defining a Nuclear.Model and for calculating various nuclear
        potentials.
"""
module  RacahAlgebra
  
    using   SymEngine,  ..AngularMomentum, ..Basics,  ..Defaults
    
    export  Kronecker, Triangle, W3j, W6j

    
    """
    `struct RacahAlgebra.AngMomentum` 
        ... defines an (abstract) data types for symbolic angular momenta which accept the types 
            Basic, Symbol, Int64 and Rational{Int64} and check for being consistent with angular momenta.
    """
    struct  AngMomentum   end

    function AngMomentum(x::Basic)   return(x)                                end
    function AngMomentum(x::Int64)   return( Basic(x) )                       end
    function AngMomentum(x::Symbol)  return( SymEngine.symbols(string(x)) )   end
    function AngMomentum(x::Rational{Int64})  
        if  x.den == 1 || x.den == 2     return( Basic(x.num//x.den) )   
        else    error("Angular momenta must be integer or half-interger.")
        end
    end


    """
    `struct  RacahAlgebra.Kronecker`  ... defines a type for a Kronecker delta symbol with symbolic arguments.

        + i, k     ::Basic   ... Kronecker indices
    """
    struct  Kronecker
        i                ::Basic
        k                ::Basic
    end


    """
    `RacahAlgebra.Kronecker(i::AngMomentum, k::AngMomentum)`  
        ... constructor for defining a Kronecker delta symbol either by Julia Symbol's or SymEngine Basic variables.
    """
    function Kronecker(i::AngMomentum, k::AngMomentum)
        wi = AngMomentum(i);    wk = AngMomentum(k)
        Kronecker(wi,wk)
    end


    # `Base.show(io::IO, delta::Kronecker)`  ... prepares a proper printout of the variable delta::Kronecker.
     function Base.show(io::IO, delta::Kronecker)
        print(io, "delta($(delta.i), $(delta.k))")
    end


    """
    `struct  RacahAlgebra.Triangle`  ... defines a type for a Triangle delta symbol with symbolic arguments.

        + ja, jb, jc     ::Basic   ... angular momenta in the Triangle delta
    """
    struct  Triangle
        ja               ::Basic
        jb               ::Basic
        jc               ::Basic
    end


    """
    `RacahAlgebra.Triangle(ja::AngMomentum, jb::AngMomentum, jc::AngMomentum)`  
        ... constructor for defining a Triangle delta symbol either by Julia Symbol's or SymEngine Basic variables.
    """
    function Triangle(ja::AngMomentum, jb::AngMomentum, jc::AngMomentum)
        wja = AngMomentum(ja);    wjb = AngMomentum(jb);    wjc = AngMomentum(jc)    
        Triangle(wja,wjb,wjc)
    end


    # `Base.show(io::IO, delta::Triangle)`  ... prepares a proper printout of the variable delta::Triangle.
     function Base.show(io::IO, delta::Triangle)
        print(io, "delta ($(delta.ja), $(delta.jb), $(delta.jc))")
    end


    """
    `struct  RacahAlgebra.W3j`  ... defines a type for a Wigner 3-j symbol with symbolic arguments.

        + ja, jb, jc     ::Basic   ... angular momenta
        + ma, mb, mc     ::Basic   ... projections of the angular momenta above
    """
    struct  W3j
        ja               ::Basic
        jb               ::Basic
        jc               ::Basic
        ma               ::Basic
        mb               ::Basic
        mc               ::Basic
    end


    """
    `RacahAlgebra.W3j(ja::AngMomentum, jb::AngMomentum, jc::AngMomentum, 
                      ma::AngMomentum, mb::AngMomentum, mc::AngMomentum)`  
        ... constructor for defining the Wigner 3-j symbol either by Julia Symbol's or SymEngine Basic variables.
    """
    function W3j(ja::AngMomentum, jb::AngMomentum, jc::AngMomentum, 
                 ma::AngMomentum, mb::AngMomentum, mc::AngMomentum)
        wja = AngMomentum(ja);    wjb = AngMomentum(jb);    wjc = AngMomentum(jc)    
        wma = AngMomentum(ma);    wmb = AngMomentum(mb);    wmc = AngMomentum(mc)    
        W3j(wja, wjb, wjc, wma, wmb, wmc)
    end


    # `Base.show(io::IO, w::W3j)`  ... prepares a proper printout of the variable  w3j::W3j.
     function Base.show(io::IO, w::W3j)
        print(io, "W3j($(w.ja), $(w.jb), $(w.jc); $(w.ma), $(w.mb), $(w.mc))")
    end


    """
    `Base.:(==)(wa::W3j, wb::W3j)`  
        ... compares two (symbolic) Wigner 3-j symbols and return true if all subfields are equal, and false otherwise.
    """
    function  Base.:(==)(wa::W3j, wb::W3j)
        if   wa.ja != wb.ja   ||   wa.jb != wb.jb   ||   wa.jc != wb.jc   ||   
             wa.ma != wb.ma   ||   wa.mb != wb.mb   ||   wa.mc != wb.mc       return( false )    
        else                                                                  return( true )    
        end
    end


    """
    `struct  RacahAlgebra.W6j`  ... defines a type for a Wigner 6-j symbol with symbolic arguments.

        + a, b, c, d, e, f     ::Basic   ... angular momenta
    """
    struct  W6j
        a                      ::Basic
        b                      ::Basic
        c                      ::Basic
        d                      ::Basic
        e                      ::Basic
        f                      ::Basic
    end


    """
    `RacahAlgebra.W6j(a::AngMomentum, b::AngMomentum, c::AngMomentum, 
                      d::AngMomentum, e::AngMomentum, f::AngMomentum)`  
        ... constructor for defining the Wigner 6-j symbol either by Julia Symbol's or SymEngine Basic variables.
    """
    function  W6j(a::AngMomentum, b::AngMomentum, c::AngMomentum, 
                  d::AngMomentum, e::AngMomentum, f::AngMomentum)
        wa = AngMomentum(a);    wb = AngMomentum(b);    wc = AngMomentum(c)    
        wd = AngMomentum(d);    we = AngMomentum(e);    wf = AngMomentum(f)    
        W6j(wa, wb, wc, wd, we, wf)
    end


    # `Base.show(io::IO, w::W6j)`  ... prepares a proper printout of the variable  w6j::W6j.
    function Base.show(io::IO, w::W6j)
        print(io, "W6j{$(w.a), $(w.b), $(w.c); $(w.d), $(w.e), $(w.f)}")
    end


    """
    `Base.:(==)(wa::W6j, wb::W6j)`  
        ... compares two (symbolic) Wigner 6j symbols and return true if all subfields are equal, and false otherwise.
    """
    function  Base.:(==)(wa::W6j, wb::W6j)
        if   wa.a != wb.a   ||   wa.b != wb.b   ||   wa.c != wb.c   ||   
             wa.d != wb.d   ||   wa.e != wb.e   ||   wa.f != wb.f             return( false )    
        else                                                                  return( true )    
        end
    end


    """
    `struct  RacahAlgebra.W9j`  ... defines a type for a Wigner 9j symbol with symbolic arguments.

        + a, b, c, d, e, f, g, h, i     ::Basic   ... angular momenta
    """
    struct  W9j
        a                      ::Basic
        b                      ::Basic
        c                      ::Basic
        d                      ::Basic
        e                      ::Basic
        f                      ::Basic
        g                      ::Basic
        h                      ::Basic
        i                      ::Basic
    end


    """
    `RacahAlgebra.W9j(a::AngMomentum, b::AngMomentum, c::AngMomentum, 
                      d::AngMomentum, e::AngMomentum, f::AngMomentum,
                      g::AngMomentum, h::AngMomentum, i::AngMomentum)`  
        ... constructor for defining the Wigner 9j symbol either by Julia Symbol's or SymEngine Basic variables.
    """
    function  W9j(a::AngMomentum, b::AngMomentum, c::AngMomentum, 
                  d::AngMomentum, e::AngMomentum, f::AngMomentum,
                  g::AngMomentum, h::AngMomentum, i::AngMomentum)
        wa = AngMomentum(a);    wb = AngMomentum(b);    wc = AngMomentum(c)    
        wd = AngMomentum(d);    we = AngMomentum(e);    wf = AngMomentum(f)    
        wg = AngMomentum(g);    wh = AngMomentum(h);    wi = AngMomentum(i)    
        W9j(wa, wb, wc, wd, we, wf, wg, wh, wi)
    end


    # `Base.show(io::IO, w::W9j)`  ... prepares a proper printout of the variable  w::W9j.
    function Base.show(io::IO, w::W9j)
        print(io, "W9j{$(w.a), $(w.b), $(w.c); $(w.d), $(w.e), $(w.f); $(w.g), $(w.h), $(w.i)}")
    end


    """
    `Base.:(==)(wa::W9j, wb::W9j)`  
        ... compares two (symbolic) Wigner 6j symbols and return true if all subfields are equal, and false otherwise.
    """
    function  Base.:(==)(wa::W9j, wb::W9j)
        if   wa.a != wb.a   ||   wa.b != wb.b   ||   wa.c != wb.c   ||   
             wa.d != wb.d   ||   wa.e != wb.e   ||   wa.f != wb.f   ||   
             wa.g != wb.g   ||   wa.h != wb.h   ||   wa.i != wb.i             return( false )    
        else                                                                  return( true )    
        end
    end


    """
    `struct  RacahAlgebra.RacahExpression`  ... defines a type for a RacahExpression with symbolic arguments.

        + summations    ::Array{Basic,1}      ... Summation indices.
        + phase         ::Basic               ... Phase of the Racah expression.
        + weight        ::Basic               ... Weight of the Racah expression.
        + deltas        ::Array{Kronecker,1}  ... List of Kronecker deltas.
        + triangles     ::Array{Triangle,1}   ... List of Triangle deltas.
        + w3js          ::Array{W3j,1}        ... List of Wigner 3-j symbols
        + w6js          ::Array{W6j,1}        ... List of Wigner 6-j symbols
        + w9js          ::Array{W9j,1}        ... List of Wigner 9-j symbols
    """
    struct  RacahExpression
        summations             ::Array{Basic,1}
        phase                  ::Basic
        weight                 ::Basic
        deltas                 ::Array{Kronecker,1}
        triangles              ::Array{Triangle,1}
        w3js                   ::Array{W3j,1} 
        w6js                   ::Array{W6j,1}
        w9js                   ::Array{W9j,1}
    end


    """
    `RacahAlgebra.RacahExpression()`  
        ... constructor for defining an empty RacahExpression.
    """
    function  RacahExpression()
        RacahExpression( Basic[], Basic(0), Basic(1), Kronecker[], Triangle[], W3j[], W6j[], W9j[] )
    end


    # `Base.show(io::IO, rex::RacahExpression)`  ... prepares a proper printout of the variable  rex::RacahExpression.
    function Base.show(io::IO, rex::RacahExpression)
        sa = "\n"
        if  rex.summations != Basic[]    sa = sa * "Sum_[$(rex.summations)]  "      end
        if  rex.phase      != Basic(0)   sa = sa * "(-1)^($(rex.phase))  "          end
        if  rex.weight     != Basic(1)   sa = sa * "($(rex.weight))  "              end
        for  delta    in rex.deltas      sa = sa * "$delta  "                       end
        for  triangle in rex.triangles   sa = sa * "$triangle  "                    end
        for  w3j      in rex.w3js        sa = sa * "$w3j  "                         end
        for  w6j      in rex.w6js        sa = sa * "$w6j  "                         end
        for  w9j      in rex.w9js        sa = sa * "$w9j  "                         end
        print(io, sa)
    end

    
    """
    `abstract type RacahAlgebra.AbstractRecursionW3j` 
        ... defines an abstract and a number of singleton types for the recursion rules for Wigner 3-j symbols.

        + RecursionW3jMagnetic      ... Recursion wrt. the magnetic quantum numbers.
        + RecursionW3jOneStep       ... Recursion with step-1 of the j-quantum numbers.
        + RecursionW3jHalfStep      ... Recursion with step-1/2 of the j-quantum numbers.
        + RecursionW3jLouck         ... Recursion wrt. j-quantum numbers due to Louck.
    """
    abstract type  AbstractRecursionW3j                             end
    struct         RecursionW3jMagnetic  <:  AbstractRecursionW3j   end
    struct         RecursionW3jOneStep   <:  AbstractRecursionW3j   end
    struct         RecursionW3jHalfStep  <:  AbstractRecursionW3j   end
    struct         RecursionW3jLouck     <:  AbstractRecursionW3j   end


    """
    `RacahAlgebra.equivalentForm(w3j::RacahAlgebra.W3j; regge::Bool=false)`  
        ... generates an (random) equivalent form for the Wigner 3j symbol w3j by using either the classical
            (regge = false) or Regge symmetries (regge = true). A rex:RacahExpression is returned.
    """
    function equivalentForm(w3j::RacahAlgebra.W3j; regge::Bool=false)
        wa  = RacahAlgebra.symmetricForms(w3j, regge=regge)
        if  regge   n = rand(1:72)    else     n = rand(1:12)   end
        println("** Select $(n)th equivalent form for $w3j    ==>   $( wa[n])")
        return( wa[n] )
    end


    """
    `RacahAlgebra.equivalentForm(w6j::RacahAlgebra.W6j; regge::Bool=false)`  
        ... generates an (random) equivalent form for the Wigner 6j symbol w6j by using either the classical
            (regge = false) or Regge symmetries (regge = true). A rex:RacahExpression is returned.
    """
    function equivalentForm(w6j::RacahAlgebra.W6j; regge::Bool=false)
        wa  = RacahAlgebra.symmetricForms(w6j, regge=regge)
        if  regge   n = rand(1:144)    else     n = rand(1:24)   end
        println("** Select $(n)th equivalent form for $w6j    ==>   $( wa[n])")
        return( wa[n] )
    end


    """
    `RacahAlgebra.equivalentForm(w9j::RacahAlgebra.W9j; regge::Bool=false)`  
        ... generates an (random) equivalent form for the Wigner 9-j symbol w9j by using either the classical
            (regge = false) or Regge symmetries (regge = true). A rex:RacahExpression is returned.
    """
    function equivalentForm(w9j::RacahAlgebra.W9j; regge::Bool=false)
        wa  = RacahAlgebra.symmetricForms(w9j, regge=regge)
        if  regge   n = rand(1:72)    else     n = rand(1:72)   end
        println("** Select $(n)th equivalent form for $w6j    ==>   $( wa[n])")
        return( wa[n] )
    end


    """
    `RacahAlgebra.equivalentForm(rex::RacahAlgebra.RacahExpression; regge::Bool=false)`  
        ... generates an (random) equivalent form for the Racah expression rex by using either the classical
            (regge = false) or Regge symmetries (regge = true) for the Wigner 3j, 6j or 9j symbols. 
            A rex:RacahExpression is returned.
    """
    function equivalentForm(rex::RacahAlgebra.RacahExpression; regge::Bool=false)
        newRex = rex;   newPhase = newRex.phase;    newW3js  = W3j[] 
        # Generate random equivalent forms of all Wigner 3j symbols
        ##x println("$(newRex)   $(newRex.w3js)")
        for (iaW3j, aW3j)  in  enumerate(newRex.w3js)
            xaRex    = RacahAlgebra.equivalentForm(aW3j, regge=regge)
            newPhase = newPhase + xaRex.phase
            push!( newW3js, xaRex.w3js[1])
        end
        newRex = RacahExpression( newRex.summations, newPhase, newRex.weight, newRex.deltas, 
                                  newRex.triangles,  newW3js, newRex.w6js, newRex.w9js )
        
        # Generate random equivalent forms of all Wigner 6j symbols
        newPhase = newRex.phase;    newW6js  = W6j[] 
        for (iaW6j, aW6j)  in  enumerate(newRex.w6js)
            xaRex    = RacahAlgebra.equivalentForm(aW6j, regge=regge)
            newPhase = newPhase + xaRex.phase
            push!( newW6js, xaRex.w6js[1])
        end
        newRex = RacahExpression( newRex.summations, newPhase, newRex.weight, newRex.deltas, 
                                  newRex.triangles,  newRex.w3js, newW6js, newRex.w9js )
        
        
        return( newRex )
    end


    """
    `RacahAlgebra.evaluate(wj::Union{W3j,W6j})`  
        ... attempts to evaluate a symbolic Wigner 3j symbol by means of special values.
    """
    function  evaluate(wj::Union{W3j,W6j})
        wa = RacahAlgebra.specialValue(wj)
        if    wa[1]   return( wa[2] )
        else          println("No special value found for:  $wj ");  
                      return( nothing )
        end
    end


    """
    `RacahAlgebra.evaluate(rex::RacahExpression)`  
        ... attempts to evaluate and symbolically simplify a Racah expression by means of special values and/or 
            sum rules. A newrex::RacahExpression is returned once a simplification has been found, and nothing
            otherwise. No attempt is presently made to find further simplication, once a rule has been applied.
    """
    function  evaluate(rex::RacahExpression)
        wa = sumRulesForOneW3j(rex);         if    wa[1]  return( wa[2] )  end
        wa = sumRulesForOneW6j(rex);         if    wa[1]  return( wa[2] )  end
        wa = sumRulesForOneW9j(rex);         if    wa[1]  return( wa[2] )  end
        
        println("\nNo simplification found for:  $rex ");  
        return( nothing )
    end


    """
    `RacahAlgebra.evaluateNumerical(w3j::W3j)`  
        ... attempts to evaluates  a Wigner 3-j symbol numerically; it is supposed that all angular momenta are given numerically.
            A wa::Float64 is returned.
    """
    function  evaluateNumerical(w3j::W3j)
        ##x println("*** w3j = $w3j")
        ja = Float64(w3j.ja);   jb = Float64(w3j.jb);   jc = Float64(w3j.jc)
        ma = Float64(w3j.ma);   mb = Float64(w3j.mb);   mc = Float64(w3j.mc)
        ##x println("*** $ja   $jb   $jc   $ma   $mb   $mc")
        wa = AngularMomentum.Wigner_3j(ja, jb, jc, ma, mb, mc)
        return( wa )
    end


    """
    `RacahAlgebra.evaluateNumerical(w6j::W6j)`  
        ... attempts to evaluates  a Wigner 6-j symbol numerically; it is supposed that all angular momenta are given numerically.
            A wa::Float64 is returned.
    """
    function  evaluateNumerical(w6j::W6j)
        ##x println("*** w6j = $w6j")
        a = Float64(w6j.a);   b  = Float64(w6j.b);   c = Float64(w6j.c)
        d = Float64(w6j.e);   ex = Float64(w6j.e);   f = Float64(w6j.f)
        wa = AngularMomentum.Wigner_6j(a,b,c, d,ex,f)
        return( wa )
    end


    """
    `RacahAlgebra.evaluateNumerical(rex::RacahExpression)`  
        ... attempts to evaluates  a Racah expression numerically; it is supposed that the phase, weight and all angular momenta 
            are given numerically. A newRex::RacahExpression is returned.
    """
    function  evaluateNumerical(rex::RacahExpression)
        wa = 1.0
        wa = wa * Float64((-1)^rex.phase) * Float64(rex.weight)
        for  w3j in rex.w3js    wa = wa * RacahAlgebra.evaluateNumerical(w3j)   end
        for  w6j in rex.w6js    wa = wa * RacahAlgebra.evaluateNumerical(w6j)   end
        for  w9j in rex.w9js    wa = wa * RacahAlgebra.evaluateNumerical(w9j)   end
        
        newRex = RacahExpression(rex.summations, 0, wa, rex.deltas, rex.triangles, W3j[], W6j[], W9j[])
        return( newRex )
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, indexList::Array{SymEngine.Basic,1})`  
        ... returns true if index is in indexList and false otherwise; this function is implemented mainly for 
            consistency reasons.
    """
    function  hasIndex(index::SymEngine.Basic, indexList::Array{SymEngine.Basic,1})
        if  index in indexList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, expr::SymEngine.Basic)`  
        ... returns true if the (symbolic) index occurs in expression and false otherwise.
    """
    function hasIndex(index::SymEngine.Basic, expr::SymEngine.Basic)
        sList = SymEngine.free_symbols(expr)
        if  index in sList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, deltas::Array{RacahAlgebra.Kronecker,1})`  
        ... returns true if the (symbolic) index occurs in the list of Kronecker deltas and false otherwise.
    """
    function hasIndex(index::SymEngine.Basic, deltas::Array{RacahAlgebra.Kronecker,1})
        sList = Basic[]
        for  delta in deltas    push!(sList, delta.i);      push!(sList, delta.k)    end
        if  index in sList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, triangles::Array{RacahAlgebra.Triangle,1})`  
        ... returns true if the (symbolic) index occurs in the list of Triangle deltas and false otherwise.
    """
    function hasIndex(index::SymEngine.Basic, triangles::Array{RacahAlgebra.Triangle,1})
        sList = Basic[]
        for  triangle in triangles    
            push!(sList, triangle.ja);    push!(sList, triangle.jb);    push!(sList, triangle.jc)
        end
        if  index in sList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, w3js::Array{RacahAlgebra.W3j,1})`  
        ... returns true if the (symbolic) index occurs in the list of Wigner 3j symbols and false otherwise.
    """
    function hasIndex(index::SymEngine.Basic, w3js::Array{RacahAlgebra.W3j,1})
        sList = Basic[]
        for  w3j in w3js    
            push!(sList, w3j.ja);    push!(sList, w3j.jb);    push!(sList, w3j.jc)
            push!(sList, w3j.ma);    push!(sList, w3j.mb);    push!(sList, w3j.mc)
        end
        if  index in sList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, w6js::Array{RacahAlgebra.W6,1})`  
        ... returns true if the (symbolic) index occurs in the list of Wigner 6j symbols and false otherwise.
    """
    function hasIndex(index::SymEngine.Basic, w6js::Array{RacahAlgebra.W6j,1})
        sList = Basic[]
        for  w6j in w6js    
            push!(sList, w6j.a);    push!(sList, w6j.b);    push!(sList, w6j.c)
            push!(sList, w6j.d);    push!(sList, w6j.e);    push!(sList, w6j.f)
        end
        if  index in sList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.hasIndex(index::SymEngine.Basic, w9js::Array{RacahAlgebra.W9,1})`  
        ... returns true if the (symbolic) index occurs in the list of Wigner 9j symbols and false otherwise.
    """
    function hasIndex(index::SymEngine.Basic, w9js::Array{RacahAlgebra.W9j,1})
        sList = Basic[]
        for  w9j in w9js    
            push!(sList, w9j.a);    push!(sList, w9j.b);    push!(sList, w9j.c)
            push!(sList, w9j.d);    push!(sList, w9j.e);    push!(sList, w9j.f)
            push!(sList, w9j.g);    push!(sList, w9j.h);    push!(sList, w9j.i)
        end
        if  index in sList    return( true )    else    false   end
    end


    """
    `RacahAlgebra.recursionW3j(ww::W3j, rule::AbstractRecursionW3j)`  
        ... applies a given recursion rules to w3j; an rexList::Array{RacahAlgebra.RacahExpression,1} is returned.
    """
    function recursionW3j(w3j::W3j, rule::AbstractRecursionW3j)
        #
        rexList = RacahExpression[]
        if      rule == RecursionW3jHalfStep()
            #
            # Half-step rule:   Rotenberg et al. (1959), Eq. (1.45).
            # ---------------
            #                  1/2  ( j1  j2  j3 )                    1/2  ( j1  j2-1/2  j3-1/2 )                    1/2  ( j1  j2-1/2  j3-1/2 )
            #   [(J+1)(J-2*j1)]     (            )  = [(j2+m2)(j3-m3)]     (                    )  - [(j2-m2)(j3+m3)]     (                    )
            #                       ( m1  m2  m3 )                         ( m1  m2-1/2  m3+1/2 )                         ( m1  m2+1/2  m3-1/2 )
            #
            #   with  J = j1+j2+j3
            #
            J = w3j.ja + w3j.jb + w3j.jc;    wa = sqrt( (J+1)*(J-2*w3j.ja) )
            rex = RacahExpression( Basic[], 0, sqrt( (w3j.jb+w3j.mb)*(w3j.jc-w3j.mc) )/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb-1//2, w3j.jc-1//2, w3j.ma, w3j.mb-1//2, w3j.mc+1//2)], W6j[], W9j[])
            push!( rexList, rex)
            rex = RacahExpression( Basic[], 0, -sqrt( (w3j.jb-w3j.mb)*(w3j.jc+w3j.mc) )/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb-1//2, w3j.jc-1//2, w3j.ma, w3j.mb+1//2, w3j.mc-1//2)], W6j[], W9j[])
            push!( rexList, rex)
            return( rexList )
            #
        elseif  rule == RecursionW3jLouck()
            #
            # Louck's rule:   Rotenberg et al. (1959), Eq. (1.46).
            # -------------
            #          1/2          (  j1     j2   j3 )                                1/2  (   j1    j2-1/2  j3-1/2 )
            #   (j2+m2)   (2*j3+1)  (                 ) == - [(J-2*j1)(J+1)(j3+m3)]     (                        )
            #                       ( m2-m3  -m2   m3 )                                     ( m2-m3  -m2+1/2  m3-1/2 )
            #                                             
            #                                                                                  1/2  (   j1    j2-1/2  j3+1/2 )
            #                                              - [(J-2*j3)(J-2*j2+1)(J+1)(j3-m3+1)]     (                        )
            #                                                                                       ( m2-m3  -m2+1/2  m3-1/2 )
            #
            #  with  J = j1+j2+j3
            #
            J = w3j.ja + w3j.jb + w3j.jc;    wa = sqrt( (w3j.jb+w3j.mb) ) * (2*w3j.jc+1)
            rex = RacahExpression( Basic[], 0, -sqrt( (J-2*w3j.ja)* (J+1) * (w3j.jc+w3j.mc) )/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb-1//2, w3j.jc-1//2, w3j.mb-w3j.mc, -w3j.mb+1//2, w3j.mc-1//2)], W6j[], W9j[])
            push!( rexList, rex)
            rex = RacahExpression( Basic[], 0, -sqrt( (J-2*w3j.jc) * (J-2*w3j.jb+1) * (J+1) * (w3j.jc-w3j.mc+1) )/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb-1//2, w3j.jc+1//2, w3j.mb-w3j.mc, -w3j.mb+1//2, w3j.mc-1//2)], W6j[], W9j[])
            push!( rexList, rex)
            return( rexList )
            #
        elseif  rule == RecursionW3jOneStep()
            #
            # One-step rule:   Rotenberg et al. (1959), Eq. (1.47).
            # --------------
            #                                    1/2  ( j1  j2  j3 )                                      1/2  ( j1   j2   j3-1 )
            #   [(J+1)(J-2*j1)(J-2*j2)(J-2*j3+1)]     (            ) == [(j2-m2)(j2+m2+1)(j3+m3)(j3+m3-1)]     (                )
            #                                         ( m1  m2  m3 )                                           ( m1  m2+1  m3-1 )
            #
            #                                         1/2  ( j1  j2  j3-1 )                                     1/2  ( j1   j2   j3-1 )
            #                  - 2*m2 [(j3+m3)(j3-m3)]     (              ) - [(j2+m2)(j2-m2+1)(j3-m3)(j3-m3-1)]     (                )
            #                                              ( m1  m2   m3  )                                          ( m1  m2-1  m3+1 )
            #
            #    with  J = j1+j2+j3
            #
            J = w3j.ja + w3j.jb + w3j.jc;    wa = sqrt( (J+1) * (J-2*w3j.ja) * (J-2*w3j.jb) * (J-2*w3j.jc+1) )
            rex = RacahExpression( Basic[], 0, sqrt( (w3j.jb-w3j.mb) * (w3j.jb+w3j.mb+1) * (w3j.jc+w3j.mc) * (w3j.jc+w3j.mc-1))/wa, 
                                   Kronecker[], Triangle[], [W3j(w3j.ja, w3j.jb, w3j.jc-1, w3j.ma, w3j.mb+1, w3j.mc-1)], W6j[], W9j[])
            push!( rexList, rex)
            rex = RacahExpression( Basic[], 0, 2*w3j.jb * sqrt( (w3j.jc+w3j.mc) * (w3j.jc-w3j.mc))/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb, w3j.jc-1, w3j.ma, w3j.mb, w3j.mc)], W6j[], W9j[])
            push!( rexList, rex)
            rex = RacahExpression( Basic[], 0, - sqrt( (w3j.jb+w3j.mb) * (w3j.jb-w3j.mb+1) * (w3j.jc-w3j.mc) * (w3j.jc-w3j.mc-1))/wa, 
                                   Kronecker[], Triangle[], [W3j(w3j.ja, w3j.jb, w3j.jc-1, w3j.ma, w3j.mb-1, w3j.mc+1)], W6j[], W9j[])
            push!( rexList, rex)
            return( rexList )
            #
        elseif  rule == RecursionW3jMagnetic()
            #
            # Magnetic rule:   Rotenberg et al. (1959), Eq. (1.47).
            # --------------
            #                            1/2   (  j1  j2    j3  )                     1/2   (  j1   j2   j3  )                     1/2   (  j1   j2   j3  )
            #   -[(j3+m1+m2+1)(j3-m1-m2)]      (                ) = [(j1+m1+1)(j1-m1)]      (                ) + [(j2+m2+1)(j2-m2)]      (                )
            #                                  (  m1  m2  -m3+1 )                           (  m1  m2+1  -m3 )                           ( m1+1  m2  -m3  )
            #
            #    with  J = j1+j2+j3
            #
            J = w3j.ja + w3j.jb + w3j.jc;    wa = - sqrt( (w3j.jc+w3j.ma+w3j.mb+1) * (w3j.jc-w3j.ma-w3j.mb) )
            rex = RacahExpression( Basic[], 0, sqrt( (w3j.ja+w3j.ma+1) * (w3j.ja-w3j.ma) )/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb, w3j.jc, w3j.ma, w3j.mb+1, -m3)], W6j[], W9j[])
            push!( rexList, rex)
            rex = RacahExpression( Basic[], 0, sqrt( (w3j.jb+w3j.mb+1) * (w3j.jb-w3j.mb) )/wa, Kronecker[], Triangle[], 
                                   [W3j(w3j.ja, w3j.jb, w3j.jc, w3j.ma+1, w3j.mb, -m3)], W6j[], W9j[])
            push!( rexList, rex)
            return( rexList )
            #
        else    error("Unrecognized recursion rule of Wigner 3j symbols.")
        end
    end

    """
    `RacahAlgebra.removeIndex(index::SymEngine.Basic, indexList::Array{SymEngine.Basic,1})`  
        ... removes the index from the given indexList; a newList::Array{SymEngine.Basic,1} is returned.
    """
    function  removeIndex(index::SymEngine.Basic, indexList::Array{SymEngine.Basic,1})
        newList = Basic[]
        for  idx in indexList
            if  idx == index
            else    push!( newList, idx)
            end
        end
        return( newList )
    end


    """
    `RacahAlgebra.selectW3j(n::Int64)`  
        ... selects one of various pre-defined Wigner 3j symbols for which usually special values are known;
            this function has been implemented mainly for test purposes. A w3j::W3j is returned. 
            If n = 99, all pre-defined Wigner 3j symbols are printed to screen and nothing is returned in this
            case.
    """
    function selectW3j(n::Int64)
        if  n == 99     for  i = 1:20   println("  $i    $(selectW3j(i))")      end
            return(nothing)
        end
        
        ja = Basic(:ja);    jb = Basic(:jb);    jc = Basic(:jc);    ma = Basic(:ma)
        
        if      n ==  1     w3j = W3j(ja, jb, jc, 0, 0, 0)
        elseif  n ==  2     w3j = W3j(ja, ja, 0, ma, -ma, 0)
        elseif  n ==  3     w3j = W3j(ja, ja-1//2, 1//2, ma, -ma-1//2, 1//2)
        elseif  n ==  4     w3j = W3j(jb+1, jb, 1, ma, -ma-1, 1)
        elseif  n ==  5     w3j = W3j(jb+1, jb, 1, ma, -ma, 0)
        elseif  n ==  6     w3j = W3j(ja, ja, 1, ma, -ma-1, 1)
        elseif  n ==  7     w3j = W3j(ja, ja, 1, ma, -ma, 0)
        elseif  n ==  8     w3j = W3j(jb+3//2, jb, 3//2, ma, -ma-3//2, 3//2)
        elseif  n ==  9     w3j = W3j(jb+3//2, jb, 3//2, ma, -ma-1//2, 1//2)
        elseif  n == 10     w3j = W3j(jb+1//2, jb, 3//2, ma, -ma-1//2, 1//2)
        elseif  n == 11     w3j = W3j(jb+2, jb, 2, ma, -ma-2, 2)
        elseif  n == 12     w3j = FAIL
        elseif  n == 13     w3j = FAIL
        elseif  n == 14     w3j = FAIL
        elseif  n == 15     w3j = FAIL
        elseif  n == 16     w3j = FAIL
        elseif  n == 17     w3j = FAIL
        elseif  n == 18     w3j = FAIL
        elseif  n == 19     w3j = FAIL
        elseif  n == 20     w3j = FAIL
        else    error("stop a")
        end
        
        return( w3j )
    end


    """
    `RacahAlgebra.selectW6j(n::Int64)`  
        ... selects one of various pre-defined Wigner 6j symbols for which usually special values are known;
            this function has been implemented mainly for test purposes. A w6j::W6j is returned. 
            If n = 99, all pre-defined Wigner 6j symbols are printed to screen and nothing is returned in this
            case.
    """
    function selectW6j(n::Int64)
        if  n == 99     for  i = 1:20   println("  $i    $(selectW6j(i))")      end
            return(nothing)
        end
        
        ja = Basic(:ja);    jb = Basic(:jb);    jc = Basic(:jc);    je = Basic(:je);    je = Basic(:je)
        
        if      n ==  1     w6j = W6j( ja, jb, jc, je, jf, 0)
        elseif  n ==  2     w6j = W6j( ja, jb, jc, 1//2, jc -1//2,  jb +1//2)
        elseif  n ==  3     w6j = W6j( ja, jb, jc, 1//2, jc +1//2,  jb +1//2)
        elseif  n ==  4     w6j = W6j( ja, jb, jc, 1, jc -1,  jb -1)
        elseif  n ==  5     w6j = FAIL
        elseif  n ==  6     w6j = FAIL
        elseif  n ==  7     w6j = FAIL
        elseif  n ==  8     w6j = FAIL
        elseif  n ==  9     w6j = FAIL
        elseif  n == 10     w6j = FAIL
        elseif  n == 11     w6j = FAIL
        elseif  n == 12     w6j = FAIL
        else    error("stop a")
        end
        
        return( w6j )
    end


    """
    `RacahAlgebra.selectRacahExpression(n::Int64)`  
        ... selects one of various pre-defined Racah expression as they often occur on the lhs of some sum rule;
            this function has been implemented mainly for test purposes. A rex::RacahExpression is returned. 
            If n = 99, all pre-defined RacahExpression are printed to screen and nothing is returned in this
            case.
    """
    function selectRacahExpression(n::Int64)
        if  n == 99     for  i = 1:20   println("  $i    $(selectRacahExpression(i))")      end
            return(nothing)
        end
        
        j = Basic(:j);    J = Basic(:J);    m = Basic(:m);    M = Basic(:M)
        a = Basic(:a);    b = Basic(:b);    X = Basic(:X);    c = Basic(:c);   
        
        if      n ==  1     w3j = W3j(j, j, J, m, -m, M)
                            rex = RacahExpression( [m], Basic(-m), Basic(1), Kronecker[], Triangle[], [w3j], W6j[], W9j[] )
        elseif  n ==  2     w6j = W6j(a, b, X, a, b, c)
                            rex = RacahExpression( [X], Basic(0), Basic(2*X+1), Kronecker[], Triangle[], W3j[], [w6j], W9j[] )
        elseif  n == 12     rex = FAIL
        else    error("stop a")
        end
        
        return( rex )
    end

    
    """
    `RacahAlgebra.specialValue(w3j::RacahAlgebra.W3j)`  
        ... attempts to find a special value for the Wigner 3j symbol w3j. 
            A (istrue, rex)::Tuple{Bool, RacahExpression} is returned, and where istrue determined of whether a 
            special value is returned in rex. For istrue = false, rex has no meaning.
    """
    function specialValue(w3j::RacahAlgebra.W3j)
        deltas = Kronecker[];    triangles = Triangle[];   w3js = W3j[];   w6js = W6j[];   w9js = W9j[]

        rexList = RacahAlgebra.symmetricForms(w3j)
        for  rex in rexList
            ww = rex.w3js[1]
            #
            #  Rule:        ( j   j   0 )           j-m     -1/2
            #  -----        (           )   =   (-1)      [j]
            #               ( m  -m   0 )
            #
            specialW3j = W3j(ww.ja, ww.ja, 0, ww.ma, -ww.ma, 0)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.ja - ww.ma, rex.weight / sqrt(2*ww.ja+1), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule:        ( j   j-1/2   1/2 )           j-m-1   (   j - m   ) 1/2
            #  -----        (                 )   =   (-1)        (-----------)
            #               ( m  -m-1/2   1/2 )                   ( 2j (2j+1) )
            #
            specialW3j = W3j(ww.ja, ww.ja-1//2, 1//2, ww.ma, -ww.ma-1//2, 1//2)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.ja - ww.ma - 1, 
                                      rex.weight * sqrt( (ww.ja - ww.ja)/(2*ww.ja * (2*ww.ja+1)) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule:        ( j+1    j    1 )           j-m-1  (    (j-m)(j-m+1)    ) 1/2
            #  -----        (               )   =   (-1)       (--------------------)
            #               (  m   -m-1   1 )                  ( (2j+3)(2j+2)(2j+1) )
            #
            specialW3j = W3j(ww.jb+1, ww.jb, 1, ww.ma, -ww.ma-1, 1)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma - 1, 
                                      rex.weight * sqrt( (ww.jb - ww.ma)*(ww.jb - ww.ma + 1)/(2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule:        ( j1  j2  j3 )        J/2 [(J-2*j1)!(J-2*j2)!(J-2*j3)!] 1/2                   (J/2)!
            #  -----        (            )  = (-1)    [---------------------------]       -----------------------------------
            #               (  0   0   0 )            [          (J+1)!           ]       (J/2 - j1)! (J/2 - j2)! (J/2 - j3)!
            #
            #               with  J = j1+j2+j3  is  even; the 3j symbol is zero if J is odd.
            #
            specialW3j = W3j(ww.ja, ww.jb, ww.jc, 0, 0, 0);     J = ww.ja + ww.jb + ww.jc
            if  ww == specialW3j
                push!( deltas, Kronecker(J, Basic(:even)) )
                wa = RacahExpression( rex.summations, rex.phase + J/2, 
                        rex.weight * sqrt( factorial(J - 2*ww.ja) * factorial(J - 2*ww.jb) * factorial(J - 2*ww.jb) / factorial(J+1) ) * 
                                      factorial(J/2) / ( factorial(J/2-ww.ja) * factorial(J/2-ww.jb) * factorial(J/2-ww.jc) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule:        ( j+1   j   1 )           j-m-1  (  2(j+m+1)(j-m+1)   ) 1/2
            #  -----        (             )   =   (-1)       (--------------------)
            #               (  m   -m   0 )                  ( (2j+3)(2j+2)(2j+1) )
            #
            specialW3j = W3j(ww.jb+1, ww.jb, 1, ww.ma, -ww.ma, 0)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma - 1, 
                        rex.weight * sqrt( 2*(ww.jb + ww.ma + 1)*(ww.jb - ww.ma + 1)/(2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule:        ( j    j     1 )           j-m  (  2*(j-m)(j+m+1)  ) 1/2
            #  -----        (              )   =   (-1)     (------------------)
            #               ( m   -m-1   1 )                ( (2j+2)(2j+1)(2j) )
            #
            specialW3j = W3j(ww.ja, ww.ja, 1, ww.ma, -ww.ma-1, 1)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.ja - ww.ma, 
                        rex.weight * sqrt( 2*(ww.ja - ww.ma)*(ww.ja + ww.ma + 1)/(2*ww.ja+2) * (2*ww.ja+1) * (2*ww.ja) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule:        ( j   j   1 )           j-m            2 m
            #  -----        (           )   =   (-1)      -----------------------
            #               ( m  -m   0 )                 ((2j+2)(2j+1)(2j))^(1/2)
            #
            specialW3j = W3j(ww.ja, ww.ja, 1, ww.ma, -ww.ma, 0)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.ja - ww.ma, 
                                      rex.weight * 2*ww.ma / sqrt( (2*ww.ja+2) * (2*ww.ja+1) * (2*ww.ja) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 1      ( j+3/2    j    3/2 )           j-m+1/2   ( (j-m-1/2)(j-m+1/2)(j-m+3/2) ) 1/2
            #  -------      (                   )   =   (-1)          (-----------------------------)
            #               (   m   -m-3/2  3/2 )                     (   (2j+4)(2j+3)(2j+2)(2j+1)  )
            #
            specialW3j = W3j(ww.jb+3//2, ww.jb, 3//2, ww.ma, -ww.ma-3//2, 3//2)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma + 1//2, 
                                      rex.weight * sqrt( ( (ww.jb-ww.ma-1//2) * (ww.jb-ww.ma+1//2) * (ww.jb-ww.ma-3//2) )/
                                                         ( (2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1) ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 2      ( j+3/2    j    3/2 )           j-m+1/2 ( 3*(j-m+1/2)(j-m+3/2)(j+m+3/2) ) 1/2
            #  -------      (                   )   =   (-1)        (-------------------------------)
            #               (   m   -m-1/2  1/2 )                   (    (2j+4)(2j+3)(2j+2)(2j+1)   )
            #
            specialW3j = W3j(ww.jb+3//2, ww.jb, 3//2, ww.ma, -ww.ma-1//2, 1//2)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma + 1//2, 
                                      rex.weight * sqrt( ( 3*(ww.jb-ww.ma+1//2) * (ww.jb-ww.ma+3//2) * (ww.jb+ww.ma+3//2) )/
                                                         ( (2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1) ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 4      ( j+1/2    j    3/2 )            j-m-1/2           (        j-m+1/2         ) 1/2
            #  -------      (                   )    =   (-1)      (j+3*m+3/2) (------------------------)
            #               (   m   -m-1/2  1/2 )                              ( (2j+3)(2j+2)(2j+1)(2j) )
            #
            #
            specialW3j = W3j(ww.jb+1//2, ww.jb, 3//2, ww.ma, -ww.ma-1//2, 1//2)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma - 1//2, 
                                      rex.weight * (ww.jb + 3*ww.ma + 3//2) *
                                      sqrt( (ww.jb-ww.ma+1//2) / ((2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1) * 2*ww.jb) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 5      ( j+2    j   2 )           j-m  (   (j-m-1)(j-m)(j-m+1)(j-m+2)   ) 1/2
            #  -------      (              )   =   (-1)     (--------------------------------)
            #               ( m    -m-2  2 )                ( (2j+5)(2j+4)(2j+3)(2j+2)(2j+1) )
            #
            specialW3j = W3j(ww.jb+2, ww.jb, 2, ww.ma, -ww.ma-2, 2)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma, 
                                      rex.weight * sqrt( (ww.jb-ww.ma-1) * (ww.jb-ww.ma) * (ww.jb-ww.ma+1) *(ww.jb-ww.ma-2) / 
                                                         ((2*ww.jb+5) * (2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2)  * (2*ww.jb+1) ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 7      ( j+2   j   2 )          j-m  ( 6 (j+m+2)(j+m+1)(j-m+2)(j-m+1) ) 1/2
            #  -------      (             )  =   (-1)     (--------------------------------)
            #               ( m    -m   0 )               ( (2j+5)(2j+4)(2j+3)(2j+2)(2j+1) )
            #
            specialW3j = W3j(ww.jb+2, ww.jb, 2, ww.ma, -ww.ma-2, 0)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma, 
                                      rex.weight * sqrt( 6* (ww.jb+ww.ma+2) * (ww.jb+ww.ma+1) * (ww.jb-ww.ma+2) * (ww.jb-ww.ma+1) / 
                                                         ((2*ww.jb+5) * (2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2)  * (2*ww.jb+1) ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 8      ( j+1    j    2 )         j-m+1    (  (j-m-1)(j-m)(j-m+1)(j+m+2)  ) 1/2
            #  -------      (               ) =   (-1)      2* (------------------------------)
            #               ( m    -m-2   2 )                  ( (2j+4)(2j+3)(2j+2)(2j+1)(2j) )
            #
            specialW3j = W3j(ww.jb+1, ww.jb, 2, ww.ma, -ww.ma-2, 2)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma + 1, 
                                      rex.weight * 2* sqrt( (ww.jb-ww.ma-1) * (ww.jb-ww.ma) * (ww.jb-ww.ma+1) * (ww.jb-ww.ma+2) / 
                                                            ((2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1)  * 2*ww.jb ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 9      ( j+1    j    2 )         j-m+1            (        (j-m+1)(j-m)          ) 1/2
            #  -------      (               ) =   (-1)     2*(j+2*m+2) (------------------------------)
            #               ( m    -m-1   1 )                          ( (2j+4)(2j+3)(2j+2)(2j+1)(2j) )
            #
            specialW3j = W3j(ww.jb+1, ww.jb, 2, ww.ma, -ww.ma-1, 1)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma + 1, 
                                      rex.weight * 2* (ww.jb+2*ww.ma+2) * sqrt( (ww.jb-ww.ma-1) * (ww.jb-ww.ma) / 
                                                           ((2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1)  * 2*ww.jb ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 10     ( j+1   j   2 )          j-m+1     (       6 (j+m+1)(j-m+1)       ) 1/2
            #  --------     (             )  =   (-1)      2*m (------------------------------)
            #               ( m    -m   0 )                    ( (2j+4)(2j+3)(2j+2)(2j+1)(2j) )
            #
            specialW3j = W3j(ww.jb+1, ww.jb, 2, ww.ma, -ww.ma, 0)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma + 1, 
                                      rex.weight * 2*ww.ma * sqrt( 6* (ww.jb-ww.ma+1) * (ww.jb-ww.ma+1) / 
                                                           ((2*ww.jb+4) * (2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1)  * 2*ww.jb ) ), 
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
            #
            #  Rule: 13     ( j   j   2 )          j-m         2 (3*m*m - j(j+1))
            #  --------     (           )  =   (-1)     ------------------------------------
            #               ( m  -m   0 )               ((2j+3)(2j+2)(2j+1)(2j)(2j-1))^(1/2)
            #
            specialW3j = W3j(ww.jb, ww.jb, 2, ww.ma, -ww.ma, 0)
            if  ww == specialW3j
                wa = RacahExpression( rex.summations, rex.phase + ww.jb - ww.ma, 
                                      rex.weight * 2* (3*ww.ma*ww.ma - ww.jb*(ww.jb+1)) / 
                                                   sqrt( (2*ww.jb+3) * (2*ww.jb+2) * (2*ww.jb+1)  * 2*ww.jb * (2*ww.jb-1) ),
                                      deltas, triangles, w3js, w6js, w9js ) 
                return( (true, wa) )
            end
        end
        
        return( (false, RacahExpression() ) )
    end


    """
    `RacahAlgebra.specialValue(w6j::RacahAlgebra.W6j)`  
        ... attempts to find a special value for the Wigner 6j symbol w6j. 
            A (istrue, rex)::Tuple{Bool, RacahExpression} is returned, and where istrue determined of whether a 
            special value is returned in rex. For istrue = false, rex has no meaning.
    """
    function specialValue(w6j::RacahAlgebra.W6j)
        deltas = Kronecker[];    triangles = Triangle[];   w3js = W3j[];   w6js = W6j[];   w9js = W9j[]

        rexList = RacahAlgebra.symmetricForms(w6j)
        for  rex in rexList
            ww = rex.w6js[1]
            #
            #                                            j1+j2+j3
            #  Rule:         ( j1   j2   j3 )        (-1)
            #  -----        {(              )}   =  --------------  t(j1,j2,j3)  d(j1,l2) d(j2,l1)
            #                ( l1   l2   0  )                   1/2
            #                                         [ j1, j2 ]
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, ww.e, ww.f, 0)
            if  ww == specialW6j
                push!( deltas, Kronecker(ww.a, ww.e) )
                push!( deltas, Kronecker(ww.b, ww.d) )
                push!( triangles, Kronecker(ww.a, ww.b, ww.c) )
                wa = RacahExpression( rex.summations, rex.phase + ww.a + ww.b + ww.c, 
                                      rex.weight / sqrt( (2*ww.a+1)*(2*ww.b+1)), deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( j1     j2      j3   )            j1+j2+j3    (     (j1+j3-j2)(j1+j2-j3+1)     ) 1/2
            #  -----        {(                     )}   =   (-1)            (--------------------------------)
            #                ( 1/2  j3-1/2  j2+1/2 )                        ( (2*j2+1)(2*j2+2)(2*j3)(2*j3+1) )
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 1//2, ww.c -1//2,  ww.b +1//2)
            if  ww == specialW6j
                wa = RacahExpression( rex.summations, rex.phase + ww.a + ww.b + ww.c, 
                                      rex.weight * sqrt( (ww.a+ww.c-ww.b)*(ww.a+ww.b-ww.c+1) /
                                                         (2*ww.b+1)*(2*ww.b+2)*2*ww.c*(2*ww.c+1) ), 
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( j1     j2      j3   )            j1+j2+j3+1   (     (j1+j2+j3+2)(j2+j3-j1+1)     ) 1/2
            #  -----        {(                     )}   =   (-1)             (----------------------------------)
            #                ( 1/2  j3+1/2  j2+1/2 )                         ( (2*j2+1)(2*j2+2)(2*j3+1)(2*j3+2) )
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 1//2, ww.c +1//2,  ww.b +1//2)
            if  ww == specialW6j
                wa = RacahExpression( rex.summations, rex.phase + ww.a + ww.b + ww.c + 1, 
                                      rex.weight * sqrt( (ww.a+ww.b+ww.c+2)*(ww.b+ww.c-ww.a+1) /
                                                         (2*ww.b+1)*(2*ww.b+2)*(2*ww.c+1)*(2*ww.c+2) ), 
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( j1   j2    j3  )            S       (           S(S+1)(S-2*j1)(S-2*j1-1)           ) 1/2
            #  -----        {(                )}   =   (-1)        (----------------------------------------------)
            #                (  1  j3-1  j2-1 )                    ( (2*j2-1)(2*j2)(2*j2+1)(2*j3-1)(2*j3)(2*j3+1) )
            #
            #                with  S = j1+j2+j3
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 1, ww.c -1,  ww.b -1)
            if  ww == specialW6j
                S = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + S, 
                                      rex.weight * sqrt( S*(S+1)*(S-2*ww.a)*(S-2*ww.a -1) /
                                                         (2*ww.b-1)* 2*ww.b * (2*ww.b+1)* (2*ww.c-1)* 2*ww.c * (2*ww.c+1) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( j1   j2   j3  )            S   (      2(S+1)(S-2*j1)(S-2*j2)(S-2*j3+1)        ) 1/2
            #  -----        {(               )}   =   (-1)    (----------------------------------------------)
            #                (  1  j3-1  j2  )                ( (2*j2)(2*j2+1)(2*j2+2)(2*j3-1)(2*j3)(2*j3+1) )
            #
            #                with  S = j1+j2+j3
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 1, ww.c -1,  ww.b)
            if  ww == specialW6j
                S = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + S, 
                                      rex.weight * sqrt( 2*(S+1)*(S-2*ww.a)*(S-2*ww.b)*(S-2*ww.c +1) /
                                                         2*ww.b * (2*ww.b+1) * (2*ww.b+2) * (2*ww.c-1) * 2*ww.c * (2*ww.c+1) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( j1   j2   j3    )            S   (     (S-2*j2-1)(S-2*j2)(S-2*j3+1)(S-2*j3+2)     ) 1/2
            #  -----        {(                 )}   =   (-1)    (------------------------------------------------)
            #                (  1  j3-1  j2+1  )                ( (2*j2+1)(2*j2+2)(2*j2+3)(2*j3-1)(2*j3)(2*j3+1) )
            #
            #                with  S = j1+j2+j3
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 1, ww.c -1,  ww.b +1)
            if  ww == specialW6j
                S = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + S, 
                                      rex.weight * sqrt( (S-2*ww.b-1)*(S-2*ww.b)*(S-2*ww.c +1)*(S-2*ww.c +2) /
                                                         (2*ww.b+1) * (2*ww.b+2) * (2*ww.b+3) * (2*ww.c-1) * 2*ww.c * (2*ww.c+1) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( j1  j2  j3  )            S+1         2 [ j2(j2+1) + j3(j3+1) -  j1(j1+1) ]
            #  -----        {(             )}   =   (-1)       ----------------------------------------------  1/2
            #                (  1  j3  j2  )                   ( (2*j2)(2*j2+1)(2*j2+2)(2*j3)(2*j3+1)(2*j3+2) )
            #
            #                with  S = j1+j2+j3
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 1, ww.c,  ww.b)
            if  ww == specialW6j
                S = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + S + 1, 
                                      rex.weight * 2 * ( ww.b*(ww.b+1) + ww.c*(ww.c+1) - ww.a*(ww.a+1) ) /
                                                       sqrt( 2*ww.b * (2*ww.b+1) * (2*ww.b+2) * 2*ww.c * (2*ww.c+1) * (2*ww.c+2) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule: 1       (  a     b      c   )            s   (         (s-1)s(s+1)(s-2*a-2)(s-2*a-1)(s-2*a)         ) 1/2
            #  -----        {(                   )}   =   (-1)    (------------------------------------------------------)
            #                ( 3/2  c-3/2  b-3/2 )                ( (2*b-2)(2*b-1)(2*b)(2*b+1)(2*c-2)(2*c-1)(2*c)(2*c+1) )
            #
            #                with  s = a + b + c
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-3//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (s-1)* s * (s+1) * (s-2*ww.a-2) * (s-2*ww.a-1) * (s-2*ww.a)/
                                                         (2*ww.b-2)*(2*ww.b-1)*2*ww.b*(2*ww.b+1) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule: 2       (  a     b      c   )            s   (       3*s(s+1)(s-2*a-1)(s-2*a)(s-2*b)(s-2*c+1)       ) 1/2
            #  -----        {(                   )}   =   (-1)    (------------------------------------------------------)
            #                ( 3/2  c-3/2  b-1/2 )                ( (2*b-1)(2*b)(2*b+1)(2*b+2)(2*c-2)(2*c-1)(2*c)(2*c+1) )
            #
            #                with  s = a + b + c
            #
            specialW6j = W6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule: 3       (  a     b      c   )            s   (   3*(s+1)(s-2*a)(s-2*b-1)(s-2*b)(s-2*c+1)(s-2*c+2)   ) 1/2
            #  -----        {(                   )}   =   (-1)    (------------------------------------------------------)
            #                ( 3/2  c-3/2  b+1/2 )                ( (2*b)(2*b+1)(2*b+2)(2*b+3)(2*c-2)(2*c-1)(2*c)(2*c+1) )
            #
            #                with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule: 4       (  a     b      c   )            s    (  (s-2*b-2)(s-2*b-1)(s-2*b)(s-2*c+1)(s-2*c+2)(s-2*c+3)  ) 1/2
            #  -----        {(                   )}   =   (-1)     (--------------------------------------------------------)
            #                ( 3/2  c-3/2  b+3/2 )                 ( (2*b+1)(2*b+2)(2*b+3)(2*b+4)(2*c-2)(2*c-1)(2*c)(2*c+1) )
            #
            #                with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule: 5       (  a     b      c   )            s                                      (                     (s+1)(s-2*a)                     ) 1/2
            #  -----        {(                   )}   =  (-1)   [2*(s-2*b)(s-2*c) - (s+2)(s-2*a-1)]  (------------------------------------------------------)
            #                ( 3/2  c-1/2  b-1/2 )                                                   ( (2*b-1)(2*b)(2*b+1)(2*b+2)(2*c-1)(2*c)(2*c+1)(2*c+2) )
            #
            #      with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 6       (  a     b      c   )            s                                     (                   (s-2*b)(s-2*c+1)                   ) 1/2
            #   -----        {(                   )}  =  (-1)  [ (s-2*b-1)(s-2*c) - 2*(s+2)(s-2*a)]  (------------------------------------------------------)
            #                 ( 3/2  c-1/2  b+1/2 )                                                  ( (2*b)(2*b+1)(2*b+2)(2*b+3)(2*c-1)(2*c)(2*c+1)(2*c+2) )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 7       ( a   b    c  )            s   (                  (s-2)(s-1)s(s+1)(s-2*a-3)(s-2*a-2)(s-2*a-1)(s-2*a) ) 1/2
            #   -----        {(             )}   =   (-1)    (---------------------------------------------------------------------)
            #                 ( 2  c-2  b-2 )                ( (2*b-3)(2*b-2)(2*b-1)(2*b)(2*b+1)(2*c-3)(2*c-2)(2*c-1)(2*c)(2*c+1)  )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 8       ( a   b    c  )            s     (     (s-1)s(s+1)(s-2*a-2)(s-2*a-1)(s-2*a)(s-2*b)(s-2*c+1)            ) 1/2
            #   -----        {(             )}   =   (-1)    2 (---------------------------------------------------------------------)
            #                 ( 2  c-2  b-1 )                  ( (2*b-2)(2*b-1)(2*b)(2*b+1)(2*b+2)(2*c-3)(2*c-2)(2*c-1)(2*c)(2*c+1)  )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 9       ( a   b    c  )            s  (       6*s*(s+1)(s-2*a-1)(s-2*b-1)(s-2*a)(s-2*b)(s-2*c+1)(s-2*c+2)  ) 1/2
            #   -----        {(             )}   =   (-1)   (--------------------------------------------------------------------)
            #                 ( 2  c-2   b  )               ( (2*b-1)(2*b)(2*b+1)(2*b+2)(2*b+3)(2*c-3)(2*c-2)(2*c-1)(2*c)(2*c+1) )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 10      ( a   b    c  )            s    (    (s+1)(s-2*a)(s-2*b-2)(s-2*b-1)(s-2*b)(s-2*c+1)(s-2*c+2)(s-2*c+3) ) 1/2
            #   -----        {(             )}   =   (-1)   2 (---------------------------------------------------------------------)
            #                 ( 2  c-2  b+1 )                 ( (2*b)(2*b+1)(2*b+2)(2*b+3)(2*b+4)(2*c-3)(2*c-2)(2*c-1)(2*c)(2*c+1)  )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 11      ( a   b    c  )            s   (  (s-2*b-3)(s-2*b-2)(s-2*b-1)(s-2*b)(s-2*c+1)(s-2*c+2)(s-2*c+3)(s-2*c+4) ) 1/2
            #   -----        {(             )}   =   (-1)    (-------------------------------------------------------------------------)
            #                 ( 2  c-2  b+2 )                ( (2*b+1)(2*b+2)(2*b+3)(2*b+4)(2*b+5)(2*c-3)(2*c-2)(2*c-1)(2*c)(2*c+1)    )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 12      ( a   b    c  )        s                                    (                           s*(s+1)(s-2*a-1)(s-2*a)                  ) 1/2
            #   -----        {(             )} = (-1)   4 [ (a+b)(a-b+1) - (c-1)(c-b+1)]  (--------------------------------------------------------------------) 
            #                 ( 2  c-1  b-1 )                                             ( (2*b-2)(2*b-1)(2*b)(2*b+1)(2*b+2)(2*c-2)(2*c-1)(2*c)(2*c+1)(2*c+2) )
            #
            #      with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 13      ( a   b    c  )        s                                (                    6*(s+1)(s-2*a)(s-2*b)(s-2*c+1)                  ) 1/2
            #   -----        {(             )} = (-1)   2 [ (a+b+1)(a-b) - c*c  + 1 ] (--------------------------------------------------------------------)
            #                 ( 2  c-1   b  )                                         ( (2*b-1)(2*b)(2*b+1)(2*b+2)(2*b+3)(2*c-2)(2*c-1)(2*c)(2*c+1)(2*c+2) )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #   Rule: 14      ( a   b    c  )        s                                     (                  (s-2*b-1)(s-2*b)(s-2*c+1)(s-2*c+2)                ) 1/2
            #   -----        {(             )} = (-1)  4 [ (a+b+2)(a-b-1) - (c-1)(b+c+2) ] (--------------------------------------------------------------------)
            #                 ( 2  c-1  b+1 )                                              ( (2*b)(2*b+1)(2*b+2)(2*b+3)(2*b+4)(2*c-2)(2*c-1)(2*c)(2*c+1)(2*c+2) )
            #
            #                 with  s = a + b + c
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:  15
            #  -----
            #
            #   Rule: 15      ( a   b   c )        s                                     (                                                                    ) 1/2
            #   -----        {(           )} = (-1)  2 [ 3*X(X-1) - 4*b*(b+1)*c*(c+1) ]  (--------------------------------------------------------------------)
            #                 ( 2   c   b )                                              ( (2*b-1)(2*b)(2*b+1)(2*b+2)(2*b+3)(2*c-1)(2*c)(2*c+1)(2*c+2)(2*c+3) )
            #
            #                 with  s = a + b + c   and   X = b*(b+1) + c*(c+1) - a*(a+1)
            #
            specialW6j = xxxW6j( ww.a, ww.b, ww.c, 3//2, ww.c-3//2,  ww.b-1//2)
            if  ww == specialW6j
                s = ww.a + ww.b + ww.c
                wa = RacahExpression( rex.summations, rex.phase + s, 
                                      rex.weight * sqrt( (3*s * (s+1) * (s-2*ww.a-1) * (s-2*ww.a) * (s-2*ww.b) * (s-2*ww.c+1)/
                                                         (2*ww.b-1)*2*ww.b*(2*ww.b+1)*(2*ww.b+2) * (2*ww.c-2)*(2*ww.c-1)*2*ww.c*(2*ww.c+1) ) ),
                                      deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
        end
        
        return( (false, RacahExpression() ) )
    end


    """
    `RacahAlgebra.specialValue(w9j::RacahAlgebra.W9j)`  
        ... attempts to find a special value for the Wigner 9-j symbol w9j. 
            A (istrue, rex)::Tuple{Bool, RacahExpression} is returned, and where istrue determined of whether a 
            special value is returned in rex. For istrue = false, rex has no meaning.
    """
    function specialValue(w9j::RacahAlgebra.W9j)
        deltas = Kronecker[];    triangles = Triangle[];   w3js = W3j[];   w6js = W6j[];   w9js = W9j[]

        rexList = RacahAlgebra.symmetricForms(w9j)
        for  rex in rexList
            ww = rex.w9js[1]
            #
            #  Rule:         ( ja   ja   0 )
            #  -----         (             )         D(ja,jc,jf)
            #               {( jc   jc   0 )}   =  -------------- 1/2
            #                (             )       [ ja, jc, jf ]
            #                ( jf   jf   0 )
            #
            specialW9j = xxxW9j( ww.a, ww.b, ww.c, ww.e, ww.f, 0)
            if  ww == specialW6j
                push!( deltas, Kronecker(ww.a, ww.e) )
                push!( deltas, Kronecker(ww.b, ww.d) )
                push!( triangles, Kronecker(ww.a, ww.b, ww.c) )
                wa = RacahExpression( rex.summations, rex.phase + ww.a + ww.b + ww.c, 
                                      rex.weight / sqrt( (2*ww.a+1)*(2*ww.b+1)), deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
            #
            #  Rule:         ( ja   jb   je )           jb+jc+je+jf      
            #  -----         (              )       (-1)                   ( ja   jb   je )
            #               {( jc   jd   je )}   =  --------------- 1/2   {(              )}
            #                (              )          [ je, jf ]          ( jd   jc   jf )
            #                ( jf   jf   0  )
            #
            specialW9j = xxxW9j( ww.a, ww.b, ww.c, ww.e, ww.f, 0)
            if  ww == specialW6j
                push!( deltas, Kronecker(ww.a, ww.e) )
                push!( deltas, Kronecker(ww.b, ww.d) )
                push!( triangles, Kronecker(ww.a, ww.b, ww.c) )
                wa = RacahExpression( rex.summations, rex.phase + ww.a + ww.b + ww.c, 
                                      rex.weight / sqrt( (2*ww.a+1)*(2*ww.b+1)), deltas, triangles, w3js, w6js, w9js )
                return( (true, wa) )
            end
        end
        
        return( (false, RacahExpression() ) )
    end


    """
    `RacahAlgebra.subs(delta::RacahAlgebra.Kronecker, subList::Array{Pair{Symbol,Rational{Int64}},1})`  
        ... substitutes in delta the symbols by the corresponding rational numbers in subList; a ww:Kronecker is returned.
    """
    function subs(delta::RacahAlgebra.Kronecker, subList::Array{Pair{Symbol,Rational{Int64}},1})
        ww = delta
        for  (a,b) in subList
            wx = SymEngine.subs(ww.i, Basic(a) => Basic(b));   ww = Kronecker(wx, ww.k)
            wx = SymEngine.subs(ww.k, Basic(a) => Basic(b));   ww = Kronecker(ww.i, wx)
        end
        return( ww )
    end


    """
    `RacahAlgebra.subs(triangle::RacahAlgebra.Triangle, subList::Array{Pair{Symbol,Rational{Int64}},1})`  
        ... substitutes in triangle the symbols by the corresponding rational numbers in subList; a ww:Triangle is returned.
    """
    function subs(triangle::RacahAlgebra.Triangle, subList::Array{Pair{Symbol,Rational{Int64}},1})
        ww = triangle
        for  (a,b) in subList
            wx = SymEngine.subs(ww.i, Basic(a) => Basic(b));   ww = Triangle(wx, ww.j, ww.k)
            wx = SymEngine.subs(ww.j, Basic(a) => Basic(b));   ww = Triangle(ww.i, wx, ww.k)
            wx = SymEngine.subs(ww.k, Basic(a) => Basic(b));   ww = Triangle(ww.i, ww.j, wx)
        end
        return( ww )
    end


    """
    `RacahAlgebra.subs(w3j::RacahAlgebra.W3j, subList::Array{Pair{Symbol,Rational{Int64}},1})`  
        ... substitutes in w3j the symbols by the corresponding rational numbers in subList; a ww:W3j is returned.
    """
    function subs(w3j::RacahAlgebra.W3j, subList::Array{Pair{Symbol,Rational{Int64}},1})
        ww = w3j
        for  (a,b) in subList
            wx = SymEngine.subs(ww.ja, Basic(a) => Basic(b));   ww = W3j(wx, ww.jb, ww.jc, ww.ma, ww.mb, ww.mc) 
            wx = SymEngine.subs(ww.jb, Basic(a) => Basic(b));   ww = W3j(ww.ja, wx, ww.jc, ww.ma, ww.mb, ww.mc) 
            wx = SymEngine.subs(ww.jc, Basic(a) => Basic(b));   ww = W3j(ww.ja, ww.jb, wx, ww.ma, ww.mb, ww.mc) 
            wx = SymEngine.subs(ww.ma, Basic(a) => Basic(b));   ww = W3j(ww.ja, ww.jb, ww.jc, wx, ww.mb, ww.mc) 
            wx = SymEngine.subs(ww.mb, Basic(a) => Basic(b));   ww = W3j(ww.ja, ww.jb, ww.jc, ww.ma, wx, ww.mc) 
            wx = SymEngine.subs(ww.mc, Basic(a) => Basic(b));   ww = W3j(ww.ja, ww.jb, ww.jc, ww.ma, ww.mb, wx) 
        end
        return( ww )
    end


    """
    `RacahAlgebra.subs(w6j::RacahAlgebra.W6j, subList::Array{Pair{Symbol,Rational{Int64}},1})`  
        ... substitutes in w6j the symbols by the corresponding rational numbers in subList; a ww:W6j is returned.
    """
    function subs(w6j::RacahAlgebra.W6j, subList::Array{Pair{Symbol,Rational{Int64}},1})
        ww = w6j
        for  (a,b) in subList
            wx = SymEngine.subs(ww.a, Basic(a) => Basic(b));   ww = W6j(wx, ww.b, ww.c, ww.d, ww.e, ww.f)
            wx = SymEngine.subs(ww.b, Basic(a) => Basic(b));   ww = W6j(ww.a, wx, ww.c, ww.d, ww.e, ww.f)
            wx = SymEngine.subs(ww.c, Basic(a) => Basic(b));   ww = W6j(ww.a, ww.b, wx, ww.d, ww.e, ww.f)
            wx = SymEngine.subs(ww.d, Basic(a) => Basic(b));   ww = W6j(ww.a, ww.b, ww.c, wx, ww.e, ww.f)
            wx = SymEngine.subs(ww.e, Basic(a) => Basic(b));   ww = W6j(ww.a, ww.b, ww.c, ww.d, wx, ww.f)
            wx = SymEngine.subs(ww.f, Basic(a) => Basic(b));   ww = W6j(ww.a, ww.b, ww.c, ww.d, ww.e, wx)
        end
        return( ww )
    end


    """
    `RacahAlgebra.subs(rex::RacahAlgebra.RacahExpression, subList::Array{Pair{Symbol,Rational{Int64}},1})`  
        ... substitutes in rex the symbols by the corresponding rational numbers in subList; a ww:RacahExpression is returned.
    """
    function subs(rex::RacahAlgebra.RacahExpression, subList::Array{Pair{Symbol,Rational{Int64}},1})
        ##x println("subList = $subList")
        summations = rex.summations;  phase     = rex.phase;    weight = rex.weight
        deltas      = Kronecker[];    triangles = Triangle[]
        w3js        = W3j[];          w6js      = W6j[];        w9js   = W9j[]
        for  (a,b) in subList
            ##x println("a = $a   b = $b")
            if   Basic(a) in summations   summations = SymEngine.subs(summations, Basic(a) => Basic(b))   end
            phase      = SymEngine.subs(phase,      Basic(a) => Basic(b))
            weight     = SymEngine.subs(weight,     Basic(a) => Basic(b))
        end
        for  delta    in rex.deltas        push!(deltas,    RacahAlgebra.subs(delta,     subList))    end
        for  triangle in rex.triangles     push!(triangles, RacahAlgebra.subs(triangle,  subList))    end
        for  w3j      in rex.w3js          push!(w3js,      RacahAlgebra.subs(w3j,       subList))    end
        for  w6j      in rex.w6js          push!(w6js,      RacahAlgebra.subs(w6j,       subList))    end
        for  w9j      in rex.w9js          push!(w9js,      RacahAlgebra.subs(w9j,       subList))    end
        
        ww = RacahExpression( summations, phase, weight, deltas, triangles, w3js, w6js, w9js)
        
        return( ww )
    end


    """
    `RacahAlgebra.symmetricForms(w3j::RacahAlgebra.W3j; regge::Bool=false)`  
        ... generates a list of equivalent symmetric forms of the Wigner 3j symbol w3j. There are 12 basic symmetric forms 
            for a 3j-symbol, including the given one, and 72 symmetries due to Regge, including the 12 classical ones.
            A rexList:Array{RacahExpression,1} is returned.
    """
    function symmetricForms(w3j::RacahAlgebra.W3j; regge::Bool=false)
        rexList = RacahExpression[]
        deltas  = Kronecker[];    triangles = Triangle[];   w3js = W3j[];   w6js = W6j[];   w9js = W9j[]
        sums    = Basic[];    phase = Basic(0);    weight = Basic(1)
        
        if regge    error("stop a")
        else
            j1 = w3j.ja;  j2 = w3j.jb;  j3 = w3j.jc;  m1 = w3j.ma;  m2 = w3j.mb;  m3 = w3j.mc
            push!( rexList, RacahExpression( sums, phase,            weight, deltas, triangles, [W3j(j1,j2,j3, m1,m2,m3)],     w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase,            weight, deltas, triangles, [W3j(j2,j3,j1, m2,m3,m1)],     w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase,            weight, deltas, triangles, [W3j(j3,j1,j2, m3,m1,m2)],     w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase + j1+j2+j3, weight, deltas, triangles, [W3j(j2,j1,j3, m2,m1,m3)],     w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase + j1+j2+j3, weight, deltas, triangles, [W3j(j1,j3,j2, m1,m3,m2)],     w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase + j1+j2+j3, weight, deltas, triangles, [W3j(j3,j2,j1, m3,m2,m1)],     w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase + j1+j2+j3, weight, deltas, triangles, [W3j(j1,j2,j3, -m1,-m2,-m3)],  w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase + j1+j2+j3, weight, deltas, triangles, [W3j(j2,j3,j1, -m2,-m3,-m1)],  w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase + j1+j2+j3, weight, deltas, triangles, [W3j(j3,j1,j2, -m3,-m1,-m2)],  w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase,            weight, deltas, triangles, [W3j(j2,j1,j3, -m2,-m1,-m3)],  w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase,            weight, deltas, triangles, [W3j(j1,j3,j2, -m1,-m3,-m2)],  w6js, w9js ) )
            push!( rexList, RacahExpression( sums, phase,            weight, deltas, triangles, [W3j(j3,j2,j1, -m3,-m2,-m1)],  w6js, w9js ) )
        end
        
        return( rexList )
    end


    """
    `RacahAlgebra.symmetricForms(w6j::RacahAlgebra.W6j; regge::Bool=false)`  
        ... generates a list of equivalent symmetric forms of the Wigner 6j symbol w6j. There are 24 basic symmetric forms 
            for a 6j-symbol, including the given one, and 144 symmetries due to Regge, including the 24 classical ones.
            A rexList:Array{RacahExpression,1} is returned.
    """
    function symmetricForms(w6j::RacahAlgebra.W6j; regge::Bool=false)
        rexList = RacahExpression[]
        deltas  = Kronecker[];    triangles = Triangle[];   w3js = W3j[];   w6js = W6j[];   w9js = W9j[]
        sums    = Basic[];    phase = Basic(0);    weight = Basic(1)
        
        if regge    error("stop a")
        else
            j1 = w6j.a;  j2 = w6j.b;  j3 = w6j.c;  j4 = w6j.d;  j5 = w6j.e;  j6 = w6j.f
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j1,j2,j3, j4,j5,j6)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j1,j3,j2, j4,j6,j5)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j2,j1,j3, j5,j4,j6)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j2,j3,j1, j5,j6,j4)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j3,j1,j2, j6,j4,j5)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j3,j2,j1, j6,j5,j6)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j1,j5,j6, j4,j2,j3)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j1,j6,j5, j4,j3,j2)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j5,j1,j6, j2,j4,j3)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j5,j6,j1, j2,j3,j4)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j6,j1,j5, j3,j4,j2)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j6,j5,j1, j3,j2,j4)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j4,j5,j3, j1,j2,j6)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j4,j3,j5, j1,j6,j2)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j5,j4,j3, j2,j1,j6)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j5,j3,j4, j2,j6,j1)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j3,j4,j5, j6,j1,j2)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j3,j5,j4, j6,j2,j1)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j4,j2,j6, j1,j5,j3)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j4,j6,j2, j1,j3,j5)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j2,j4,j6, j5,j1,j3)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j2,j6,j4, j5,j3,j1)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j6,j4,j2, j3,j1,j5)], w9js ) )
            push!( rexList, RacahExpression( sums, phase, weight, deltas, triangles, w3js, [W6j(j6,j2,j4, j3,j5,j1)], w9js ) )
        end
        
        return( rexList )
    end


    """
    `RacahAlgebra.sumRulesForOneW3j(rex::RacahAlgebra.RacahExpression)`  
        ... attempts to find a simplification of the given Racah expression by using sum rules for one Wigner 3j symbol. 
            Once a simplification is found, no attempt is made to find another simplifcation for this set of rules.
            A (istrue, rex)::Tuple{Bool, RacahExpression} is returned but where rex has no meaning for !istrue.
    """
    function sumRulesForOneW3j(rex::RacahAlgebra.RacahExpression)
        
        # Loop through all Wigner 3j symbols
        for  (iaW3j, aW3j) in enumerate(rex.w3js)
            aRexList = RacahAlgebra.symmetricForms(aW3j)
            for  xaRex in aRexList
                ww = xaRex.w3js[1]
                #
                #   Rule:                  -m   ( j  j J )         -j
                #   ----        Sum(m) (-1)     (        )  =  (-1)    (2j + 1)  delta(J,0)  delta(M,0)
                #                               ( m -m M )
                #
                specialW3j = W3j(ww.ja, ww.ja, ww.jc, ww.ma, -ww.ma, ww.mc)
                if  ww == specialW3j
                    newPhase  = rex.phase  + xaRex.phase;       newWeight = rex.weight * xaRex.weight
                    testPhase = newPhase   + ww.ma
                    newW3js   = W3j[];       for (ibW3j, bW3j) in enumerate(rex.w3js)  if  iaW3j != ibW3j   push!(newW3js, bW3j)   end   end
                    ##x println("*** newPhase = $newPhase   testPhase = $testPhase   newWeight = $newWeight")
                    ##x println("hasIndex - summation   = $(RacahAlgebra.hasIndex(ww.ma, rex.summations))")
                    ##x println("hasIndex - newPhase    = $(RacahAlgebra.hasIndex(ww.ma, newPhase))")
                    ##x println("hasIndex - testPhase   = $(RacahAlgebra.hasIndex(ww.ma, testPhase))")
                    ##x println("hasIndex - newWeight   = $(RacahAlgebra.hasIndex(ww.ma, newWeight))")
                    #
                    if   RacahAlgebra.hasIndex(ww.ma, rex.summations)    &&  
                         RacahAlgebra.hasIndex(ww.ma, newPhase)          &&  !RacahAlgebra.hasIndex(ww.ma, testPhase)
                        !RacahAlgebra.hasIndex(ww.ma, newWeight)         &&
                        !RacahAlgebra.hasIndex(ww.ma, rex.deltas)        &&  !RacahAlgebra.hasIndex(ww.ma, rex.triangles) 
                        !RacahAlgebra.hasIndex(ww.ma, rex.w6js)          &&  !RacahAlgebra.hasIndex(ww.ma, rex.w9js) 
                        newSummations = RacahAlgebra.removeIndex(ww.ma, rex.summations)
                        newDeltas = rex.deltas;      push!( newDeltas, Kronecker(ww.jc, 0));     push!( newDeltas, Kronecker(ww.mc, 0))
                        wa = RacahExpression( newSummations, newPhase + ww.ma - ww.ja, newWeight * (2*ww.ja+1), 
                                              newDeltas, rex.triangles, newW3js, rex.w6js, rex.w9js )
                        println("** Apply sum rule for one W3j.")
                        return( (true, wa) )
                    end
                end
            end
        end
        
        return( (false, RacahExpression()) )
    end


    """
    `RacahAlgebra.sumRulesForOneW6j(rex::RacahAlgebra.RacahExpression)`  
        ... attempts to find a simplification of the given Racah expression by using sum rules for one Wigner 6-j symbol. 
            Once a simplification is found, no attempt is made to find another simplifcation for this set of rules.
            A (istrue, rex)::Tuple{Bool, RacahExpression} is returned but where rex has no meaning for !istrue.
    """
    function sumRulesForOneW6j(rex::RacahAlgebra.RacahExpression)
        
        # Loop through all Wigner 6-j symbols
        for  (iaW6j, aW6j) in enumerate(rex.w6js)
            aRexList = RacahAlgebra.symmetricForms(aW6j)
            for  xaRex in aRexList
                ww = xaRex.w6js[1]
                #
                #   Rule:                     ( a  b  X )         2c
                #   ----        Sum(X)  [X]  {(         )}  = (-1)    delta(a,b,c)
                #                             ( a  b  c )
                #
                specialW6j = W6j(ww.a, ww.b, ww.c, ww.a, ww.b, ww.f)
                if  ww == specialW6j
                    newPhase   = rex.phase  + xaRex.phase;       newWeight = rex.weight * xaRex.weight
                    testWeight = newWeight / (2*ww.c+1)
                    newW6js    = W6j[];       for (ibW6j, bW6j) in enumerate(rex.w6js)  if  iaW6j != ibW6j   push!(newW6js, bW6j)   end   end
                    #
                    if   RacahAlgebra.hasIndex(ww.c, rex.summations)     &&  !RacahAlgebra.hasIndex(ww.c, newPhase)
                         RacahAlgebra.hasIndex(ww.c, newWeight)          &&  !RacahAlgebra.hasIndex(ww.c, testWeight)
                        !RacahAlgebra.hasIndex(ww.c, rex.deltas)         &&  !RacahAlgebra.hasIndex(ww.c, rex.triangles) 
                        !RacahAlgebra.hasIndex(ww.c, rex.w3js)           &&  !RacahAlgebra.hasIndex(ww.c, rex.w9js) 
                        newSummations = RacahAlgebra.removeIndex(ww.c, rex.summations)
                        newTriangles  = rex.triangles;      push!( newTriangles, Triangle(ww.a, ww.b, ww.f) )
                        wa = RacahExpression( newSummations, newPhase + 2*ww.f, newWeight / (2*ww.c+1), 
                                              rex.deltas, newTriangles, rex.w3js, newW6js, rex.w9js )
                        println("** Apply sum rule for one W6j -- Sum(X).")
                        return( (true, wa) )
                    end
                end
                #
                #   Rule:                     ( a  b  X )         2c
                #   ----        Sum(X)  [X]  {(         )}  = (-1)    delta(a,b,c)
                #                             ( a  b  c )
                #
               #
               #  Rule :
               #
               #              X       ( a  b  X )          -a-b      1/2
               #   Sum(X) (-1)  [X]  {(         )}  =  (-1)     [a,b]    delta(c,0)
               #                      ( b  a  c )
               #
                specialW6j = W6j(ww.a, ww.b, ww.c, ww.a, ww.b, ww.f)
                if  ww == specialW6j
                    newPhase   = rex.phase  + xaRex.phase;       newWeight = rex.weight * xaRex.weight
                    testWeight = newWeight / (2*ww.c+1)
                    newW6js    = W6j[];       for (ibW6j, bW6j) in enumerate(rex.w6js)  if  iaW6j != ibW6j   push!(newW6js, bW6j)   end   end
                    println("*** newPhase = $newPhase   testWeight = $testWeight   newWeight = $newWeight")
                    println("hasIndex - summation   = $(RacahAlgebra.hasIndex(ww.c, rex.summations))")
                    println("hasIndex - newPhase    = $(RacahAlgebra.hasIndex(ww.c, newPhase))")
                    println("hasIndex - testWeight  = $(RacahAlgebra.hasIndex(ww.c, testWeight))")
                    println("hasIndex - newWeight   = $(RacahAlgebra.hasIndex(ww.c, newWeight))")
                    #
                    if   RacahAlgebra.hasIndex(ww.c, rex.summations)     &&  !RacahAlgebra.hasIndex(ww.c, newPhase)
                         RacahAlgebra.hasIndex(ww.c, newWeight)          &&  !RacahAlgebra.hasIndex(ww.c, testWeight)
                        !RacahAlgebra.hasIndex(ww.c, rex.deltas)         &&  !RacahAlgebra.hasIndex(ww.c, rex.triangles) 
                        !RacahAlgebra.hasIndex(ww.c, rex.w3js)           &&  !RacahAlgebra.hasIndex(ww.c, rex.w9js) 
                        newSummations = RacahAlgebra.removeIndex(ww.c, rex.summations)
                        newTriangles  = rex.triangles;      push!( newTriangles, Triangle(ww.a, ww.b, ww.f) )
                        wa = RacahExpression( newSummations, newPhase + 2*ww.f, newWeight / (2*ww.c+1), 
                                              rex.deltas, newTriangles, rex.w3js, newW6js, rex.w9js )
                        println("** Apply sum rule for one W6j.")
                        return( (true, wa) )
                    end
                end
            end
        end
        
        return( (false, RacahExpression()) )
    end

end # module

#==

Sum rules for oneW6j

               #
               #  Rule :
               #                 ( a  b  X )         2c
               #   Sum(X)  [X]  {(         )}  = (-1)    delta(a,b,c)
               #                 ( a  b  c )
               #
               if  eval(w6jas[2] - w6jas[5]) = 0  and
                   eval(w6jas[3] - w6jas[6]) = 0  and
                   eval(w6jas[4] - X       ) = 0  then
                  #
                  #  break if X appears twice in w6jas:
                  #
                  if  has(subsop(4=NULL,w6jas),X)  then
                     ias := nas;
                     break
                  end if;
                  #
                  if  has(Rexpr[5],X)  then
                     error `simplify delta factors which include summation indices before an evaluation is attempted`
                  end if;
                  #
                  Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras);
                  Rwork := Racah_deletewnj(w6ja,w6jas,Rwork);
                  Rph1  := Racah_extractphase(X,Rwork);
                  #
                  if  modp(Rph1/X,4) = 2  then
                     Rwork := Racah_deletephase(Rph1,Rwork);
                     Rwork := Racah_addphase(-2*w6jas[2]-2*w6jas[3],Rwork)
                  end if;
                  if  modp(Rph1/X,4) = 0  then
                     Rwork := Racah_deletefactor(2*X+1,Rwork);
                     Rwork := Racah_deletephase(Rph1,Rwork);
                     Rwork := Racah_deletesummation({X},Rwork);
                     Rwork := Racah_addphase(2*w6jas[7],Rwork);
                     Rwork := Racah_adddeltas([`triangle#`,w6jas[2],w6jas[3],w6jas[7]],Rwork);
                     Rwork := Racah_simplifyfactor(Rwork);
                     #
                     xprint( `Before RETURN(Rwork)` );
                     Racah_xprint(Rwork);
                     if  not has(Rwork,{X})  then
                        return Rwork
                     end if
                  end if
               end if;
               #
               #  Rule :
               #
               #              X       ( a  b  X )          -a-b      1/2
               #   Sum(X) (-1)  [X]  {(         )}  =  (-1)     [a,b]    delta(c,0)
               #                      ( b  a  c )
               #
               if  eval(w6jas[2] - w6jas[6]) = 0  and
                   eval(w6jas[3] - w6jas[5]) = 0  and
                   eval(w6jas[4] - X       ) = 0  then
                  #

Sum rules for oneW9j


               w9jas := Racahexpras[6][2];
               if  eval( w9jas[10] - X ) = 0  then
                  #
                  #  Rule :
                  #
                  #                 ( a  b  e )      1
                  #   Sum(X)  [X]  {( c  d  f )}  = --- d(b,c) d(a,b,e) d(b,d,f)
                  #                 ( e  f  X )     [b]
                  #
                  if  eval(w9jas[4] - w9jas[8]) = 0  and
                      eval(w9jas[7] - w9jas[9]) = 0  then
                     #
                     if  has(subsop(10=NULL,w9jas),X)  then
                        ias := nas;
                        break
                     end if;
                     if  has(Rexpr[5],X)  then
                        error `simplify delta factors which include summation indices before an evaluation is attempted`
                     end if;
                     Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras);
                     Rwork := Racah_deletewnj(w9ja,w9jas,Rwork);
                     Rph1  := Racah_extractphase(X,Rwork);
                     #
                     replace := false;
                     if  modp(Rph1/X,4) = 0  then
                        Rwork := Racah_deletephase(Rph1,Rwork);
                        replace := true
                     elif  modp(Rph1/X,4) = 2  then
                        Rwork := Racah_deletephase(Rph1,Rwork);
                        Rwork := Racah_addphase(-2*w9jas[2]-2*w9jas[3]-2*w9jas[5]-2*w9jas[6],Rwork);
                        replace := true
                     end if;
                     #
                     if  replace  then
                        Rwork := Racah_deletesummation({X},Rwork);
                        Rwork := Racah_deletefactor(2*X+1,Rwork);
                        Rwork := Racah_addfactor(1/(2*w9jas[3]+1),Rwork);
                        Rwork := Racah_adddeltas([`delta#`,w9jas[3],w9jas[5]],
                                                 [`triangle#`,w9jas[2],w9jas[3],w9jas[4]],
                                                 [`triangle#`,w9jas[3],w9jas[6],w9jas[9]],Rwork);
                        Rwork := Racah_simplifyfactor(Rwork);
                        #
                        xprint(`Before RETURN(Rwork)`);
                        Racah_xprint(Rwork);
                        if  not has(Rwork,{X})  then
                           return Rwork
                        end if
                     end if
                  end if;
                  #
                  #  Rule :
                  #
                  #              -X      ( a  b  e )
                  #   Sum(X) (-1)  [X]  {( c  d  f )}  =
                  #                      ( f  e  X )
                  #
                  #                 -a-b-c-d   1
                  #          =  (-1)          ---  d(a,d) d(d,b,e) d(a,c,f)
                  #                           [a]
                  #

Sum rules for twoW3j

                     #
                     #  Rule :
                     #
                     #                   ( j1 j2 j3 ) ( j1  j2  j3 )
                     #   Sum(j3,m3) [j3] (          ) (            )
                     #                   ( m1 m2 m3 ) ( m1p m2p m3 )
                     #
                     #
                     #                                 =  d(m1,m1p) d(m2,m2p)
                     #
                     if  eval(w3jas[2] - w3jbs[2]) = 0  and
                         eval(w3jas[3] - w3jbs[3]) = 0  and
                         eval(w3jas[4] - w3jbs[4]) = 0  and
                         eval(w3jas[7] - w3jbs[7]) = 0  and
                         type(w3jas[4],name)            and
                         type(w3jas[7],name)            and
                         member(w3jas[4],Rsumset)       and
                         member(w3jas[7],Rsumset)       then
                        #
                        j3 := w3jas[4];  m3 := w3jas[7];
                        indep1 := Racah_extractindexdependence(j3,Rexpr);
                        indep2 := Racah_extractindexdependence(m3,Rexpr);
                        if  member(0,indep1)  or  member(0,indep2)  then
                           error `simplify delta factors which include summation indices before an evaluation is attempted`
                        else
                           independent := true;
                           for  i  from 2 to nops(Rexpr[6])  do
                              if  member(i,indep1)  and  not member(i,{ia,ib})  then
                                 independent := false;
                                 break
                              elif  member(i,indep2)  and  not member(i,{ia,ib})  then
                                 independent := false;
                                 break
                              end if
                           end do
                        end if;
                        #
                        if  independent  then
                           Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras,Racahexprbs);
                           Rwork := Racah_deletewnj(w3ja,w3jas,w3jb,w3jbs,Rwork);
                           Rxf1  := Racah_extractfactor(j3,Rwork[4]);
                           Rxf2  := Racah_extractfactor(m3,Rwork[4]);
                           Rph1  := Racah_extractphase(j3,Rwork);
                           Rph2  := Racah_extractphase(m3,Rwork);
                           #
                           replace1 := false;  replace2 := false;
                           if  Rxf1 = 2*j3 + 1  and  Rxf2 = FAIL  then
                              if  mods(Rph1/j3,4) = 0  then
                                 Rwork := Racah_deletephase(Rph1,Rwork);
                                 replace1 := true
                              elif  mods(Rph1/j3,4) = 2  then
                                 Rwork := Racah_deletephase(Rph1,Rwork);
                                 Rwork := Racah_addphase(-2*w3jas[2]-2*w3jas[3],Rwork);
                                 replace1 := true
                              end if;
                              #
                              if  mods(Rph2/m3,4) = 0  then
                                 Rwork := Racah_deletephase(Rph2, Rwork);
                                 replace2 := true
                              elif  mods(Rph2/m3,4) = 2  then
                                 Rwork := Racah_deletephase(Rph2,Rwork);
                                 Rwork := Racah_addphase(-2*w3jas[5]-2*w3jas[6],Rwork);
                                 replace2 := true
                              end if;
                              #
                              if  replace1  and  replace2  then
                                 Rwork := Racah_deletesummation({j3,m3},Rwork);
                                 Rwork := Racah_deletefactor(Rxf1,Rwork);
                                 Rwork := Racah_adddeltas([`delta#`,w3jas[5],w3jbs[5]],
                                                          [`delta#`,w3jas[6],w3jbs[6]],Rwork);
                                 #
                                 xprint(`Before RETURN(Rwork)`);
                                 Racah_xprint(Rwork);
                                 if  not has(Rwork,{j3,m3})  then
                                    return Rwork
                                 end if
                              end if
                           end if
                        end if
                     end if;
                     #
                     #  Rule :
                     #
                     #               ( j1 j2 j3 ) ( j1 j2 j3p )
                     #   Sum(m1,m2)  (          ) (           )
                     #               ( m1 m2 m3 ) ( m1 m2 m3p )
                     #
                     #                         d(j3,j3p) d(m3,m3p)
                     #                     =   ------------------- d(j1,j2,j3)
                     #                               [j3]
                     #
                     if  eval(w3jas[2] - w3jbs[2]) = 0  and
                         eval(w3jas[3] - w3jbs[3]) = 0  and
                         eval(w3jas[5] - w3jbs[5]) = 0  and
                         eval(w3jas[6] - w3jbs[6]) = 0  and
                         (type(w3jas[5],name)  or  type(-w3jas[5],name))            and
                         (type(w3jas[6],name)  or  type(-w3jas[6],name))            and
                         (member(w3jas[5],Rsumset)  or  member(-w3jas[5],Rsumset))  and
                         (member(w3jas[6],Rsumset)  or  member(-w3jas[6],Rsumset))  then
                        #
                        if  type(w3jas[5],name)  then
                           m1 :=  w3jas[5];  m1x := w3jas[5]
                        else
                           m1 := -w3jas[5];  m1x := w3jas[5]
                        end if;
                        if  type(w3jas[6],name)  then
                           m2 :=  w3jas[6];  m2x := w3jas[6]
                        else
                           m2 := -w3jas[6];  m2x := w3jas[6]
                        end if;
                        indep1 := Racah_extractindexdependence(m1,Rexpr);
                        indep2 := Racah_extractindexdependence(m2,Rexpr);
                        if  member(0,indep1)  or  member(0,indep2)  then
                           error `simplify delta factors which include summation indices before an evaluation is attempted`
                        else
                           independent := true;
                           for  i  from 2 to nops(Rexpr[6])  do
                              if  member(i,indep1)  and  not member(i,{ia,ib})  then
                                 independent := false;
                                 break
                              elif  member(i,indep2)  and  not member(i,{ia,ib})  then
                                 independent := false;
                                 break
                              end if
                           end do
                        end if;
                        #
                        if  independent  then
                           Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras,Racahexprbs);
                           Rwork := Racah_deletewnj(w3ja,w3jas,w3jb,w3jbs,Rwork);
                           if  m1 <> m1x  then  Rwork := subs(m1=m1x,Rwork)  end if;
                           if  m2 <> m2x  then  Rwork := subs(m2=m2x,Rwork)  end if;
                           Rxf1  := Racah_extractfactor(m1,Rwork[4]);
                           Rxf2  := Racah_extractfactor(m2,Rwork[4]);
                           Rph1  := Racah_extractphase(m1,Rwork);
                           Rph2  := Racah_extractphase(m2,Rwork);
                           #
                           replace1 := false;  replace2 := false;
                           if  Rxf1 = FAIL  and  Rxf2 = FAIL  then
                              if  mods(Rph1/m1,4) = 0  then
                                 Rwork := Racah_deletephase(Rph1, Rwork);
                                 replace1 := true
                              elif  mods(Rph1/m1,4) = 2  then
                                 Rwork := Racah_deletephase(Rph1,Rwork);
                                 Rwork := Racah_addphase(-2*w3jas[2],Rwork);
                                 replace1 := true
                              end if;
                              #
                              if  mods(Rph2/m2,4) = 0  then
                                 Rwork := Racah_deletephase(Rph2, Rwork);
                                 replace2 := true
                              elif  mods(Rph2/m2,4) = 2  then
                                 Rwork := Racah_deletephase(Rph2,Rwork);
                                 Rwork := Racah_addphase(-2*w3jas[3],Rwork);
                                 replace2 := true
                              end if;
                              #
                              if  replace1  and  replace2  then
                                 Rwork := Racah_deletesummation({m1,m2},Rwork);
                                 Rwork := Racah_addfactor(1/(2*w3jas[4]+1),Rwork);
                                 Rwork := Racah_adddeltas([`delta#`,w3jas[4],w3jbs[4]],
                                                          [`delta#`,w3jas[7],w3jbs[7]],
                                                          [`triangle#`,w3jas[2],w3jas[3],w3jas[4]],Rwork);
                                 #
                                 xprint(`Before RETURN(Rwork)`);
                                 Racah_xprint(Rwork);
                                 if  not has(Rwork,{m1,m2})  then
                                    return Rwork
                                 end if
                              end if
                           end if
                        end if
                     end if;
                     #
                     #  Rule :
                     #
                     #                  -np-nq  (  a  p  q  ) (  p   q  a'  )
                     #   Sum(np,nq) (-1)        (           ) (             )
                     #                          ( -na np nq ) ( -np -nq na` )
                     #
                     #                   a+na-p-q
                     #               (-1)
                     #          =   --------------  d(a,a') d(na,na') d(j1,j2,j3)
                     #                    [a]
                     #

Sum rules for twoW3j  -- loop rule

   #
   #                ( j1 j2 j3 ) ( j1 j2 j3p )
   #   Sum(m1,m2)   (          ) (           )
   #                ( m1 m2 m3 ) ( m1 m2 m3p )
   #
   #                         d(j3,j3p) d(m3,m3p)
   #                     =   ------------------- d(j1,j2,j3)
   #                               [j3]
   #


Sum rules for twoW6j
   
                        #
                        #  Rule :
                        #                                     2
                        #                         ( X  Y  Z )
                        #   Sum(X,Y,Z)  [X,Y,Z]  {(         )}    =    [a,b,c]
                        #                         ( a  b  c )
                        #
                        X := w6jas[2];  Y := w6jas[3];  Z := w6jas[4];
                        if  nops({X,Y,Z}) = 3                          and
                            Racah_extractfactor(X,Rexpr[4]) = 2*X + 1  and
                            Racah_extractfactor(Y,Rexpr[4]) = 2*Y + 1  and
                            Racah_extractfactor(Z,Rexpr[4]) = 2*Z + 1  then
                           #
                           if  has(subsop(2=NULL,3=NULL,4=NULL,w6jas),{X,Y,Z})  then
                              ias := nas;  ibs := nbs;
                              break
                           end if;
                           if  has(Rexpr[5],{X,Y,Z})  then
                              error `simplify delta factors which include summation indices before an evaluation is attempted`
                           end if;
                           #
                           Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras,Racahexprbs);
                           Rwork := Racah_deletewnj(w6ja,w6jas,w6jb,w6jbs,Rwork);
                           Rph1  := Racah_extractphase(X,Rwork);
                           Rph2  := Racah_extractphase(Y,Rwork);
                           Rph3  := Racah_extractphase(Z,Rwork);
                           #
                           replace := true;
                           if  mods(Rph1/X,4) = 0  then
                              Rwork := Racah_deletephase(Rph1,Rwork)
                           elif  mods(Rph1/X,4) = 2  then
                              Rwork := Racah_deletephase(Rph1,Rwork);
                              Rwork := Racah_addphase(-2*w6jas[6]-2*w6jas[7],Rwork)
                           else
                              replace = false
                           end if;
                           if  mods(Rph2/Y,4) = 0  then
                              Rwork := Racah_deletephase(Rph2,Rwork)
                           elif  mods(Rph2/Y,4) = 2  then
                              Rwork := Racah_deletephase(Rph2,Rwork);
                              Rwork := Racah_addphase(-2*w6jas[5]-2*w6jas[7],Rwork)
                           else
                              replace = false
                           end if;
                           if  mods(Rph3/Z,4) = 0  then
                              Rwork := Racah_deletephase(Rph3,Rwork)
                           elif  mods(Rph3/Z,4) = 2  then
                              Rwork := Racah_deletephase(Rph3,Rwork);
                              Rwork := Racah_addphase(-2*w6jas[5]-2*w6jas[6],Rwork)
                           else
                              replace = false
                           end if;
                           #
                           if  replace  then
                              Rwork := Racah_deletesummation({X,Y,Z},Rwork);
                              Rwork := Racah_deletefactor((2*X+1)*(2*Y+1)*(2*Z+1),Rwork);
                              Rwork := Racah_addfactor((2*w6jas[5]+1)*(2*w6jas[6]+1)*(2*w6jas[7]+1),Rwork);
                              Rwork := Racah_simplifyfactor(Rwork);
                              #
                              xprint(`Before RETURN(Rwork)`);
                              Racah_xprint(Rwork);
                              if  not has(Rwork,{X,Y,Z})  then
                                 return Rwork
                              end if
                           end if
                        end if
                     end if;
                     #
                     #  Rule :
                     #
                     #              X     ( a  b  X )   ( c  d  X )
                     #   Sum(X) (-1) [X] {(         )} {(         )}
                     #                    ( c  d  p )   ( b  a  q )
                     #
                     #                                   -p-q    ( c  a  q )
                     #                            =  (-1)       {(         )}
                     #                                           ( d  b  p )
                     #
                     if  eval(w6jas[2] - w6jbs[6]) = 0  and
                         eval(w6jas[3] - w6jbs[5]) = 0  and
                         eval(w6jas[4] - w6jbs[4]) = 0  and
                         eval(w6jas[5] - w6jbs[2]) = 0  and
                         eval(w6jas[6] - w6jbs[3]) = 0  and
                         eval(w6jas[4] - X       ) = 0  then
                        #
                        if  has([subsop(4=NULL,w6jas),subsop(4=NULL,w6jbs)],X)  then
                           ias := nas;  ibs := nbs;
                           break
                        end if;
                        if  has(Rexpr[5],X)  then
                           error `simplify delta factors which include summation indices before an evaluation is attempted`
                        end if;
                        #
                        Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras,Racahexprbs);
                        Rwork := Racah_deletewnj(w6ja,w6jas,w6jb,w6jbs,Rwork);
                        Rph1  := Racah_extractphase(X,Rwork);
                        #
                        replace := false;
                        if  mods(Rph1/X,4) = 1  then
                           Rwork := Racah_deletephase(Rph1,Rwork);
                           replace := true
                        elif  mods(Rph1/X,4) = -1  then
                           Rwork := Racah_deletephase(Rph1,Rwork);
                           Rwork := Racah_addphase(-2*w6jas[2]-2*w6jas[3],Rwork);
                           replace := true
                        end if;
                        #
                        if  replace  then
                           w6jn  := Racah_setw6j(w6jas[5],w6jas[2],w6jbs[7],w6jas[6],w6jas[3],w6jas[7]);
                           Rwork := Racah_deletesummation({X},Rwork);
                           Rwork := Racah_deletefactor(2*X+1,Rwork);
                           Rwork := Racah_addwnj(w6jn,Rwork);
                           Rwork := Racah_addphase(-w6jas[7]-w6jbs[7],Rwork);
                           Rwork := Racah_simplifyfactor(Rwork);
                           #
                           xprint(`Before RETURN(Rwork)`);
                           Racah_xprint(Rwork);
                           if  not has(Rwork,{X})  then
                              return Rwork
                           end if
                        end if
                     end if;
                     #
                     #  Rule :
                     #
                     #                ( a  b  X )   ( c  d  X )
                     #   Sum(X) [X]  {(         )} {(         )}
                     #                ( c  d  p )   ( a  b  q )
                     #
                     #                           1
                     #                      =   ---  d(p,q) d(a,d,p) d(b,c,p)
                     #                          [p]
                     #
                     if  eval(w6jas[2] - w6jbs[5]) = 0  and
                         eval(w6jas[3] - w6jbs[6]) = 0  and
                         eval(w6jas[4] - w6jbs[4]) = 0  and
                         eval(w6jas[5] - w6jbs[2]) = 0  and
                         eval(w6jas[6] - w6jbs[3]) = 0  and
                         eval(w6jas[4] - X       ) = 0  then
                        #
                        if  has([subsop(4=NULL,w6jas),subsop(4=NULL,w6jbs)],X)  then
                           ias := nas;  ibs := nbs;
                           break
                        end if;
                        if  has(Rexpr[5],X)  then
                           error `simplify delta factors which include summation indices before an evaluation is attempted`
                        end if;
                        #
                        Rwork := Racah_addRacahexpressions(Rexpr,Racahexpras,Racahexprbs);
                        Rwork := Racah_deletewnj(w6ja,w6jas,w6jb,w6jbs,Rwork);
                        Rph1  := Racah_extractphase(X,Rwork);
                        #
                        replace := false;
                        if  mods(Rph1/X,4) = 0  then
                           Rwork := Racah_deletephase(Rph1,Rwork);
                           replace := true
                        elif  mods(Rph1/X,4) = 2  then
                           Rwork := Racah_deletephase(Rph1,Rwork);
                           Rwork := Racah_addphase(-2*w6jas[2]-2*w6jas[3],Rwork);
   


==#