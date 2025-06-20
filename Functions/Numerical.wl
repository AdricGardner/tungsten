(* ::Package:: *)

(* ::Section:: *)
(*Usage*)


Euler::usage = "Runs Euler's method.";

Newton::usage = "Runs the Newton Rhaphson method. Input is Newton[f[x],x,x0,iterations]";

FindRoots::usage = "FindRoot but it attempts to find more than one root. Input is FindRoots[function,{variable,min,max}]"

ImpDiff::usage = "Implicitly differentiates an expression once or twice. Input is ImpDiff[expression,{x,y,number of difs}]"

ForceSolve::usage = "Forces Mathematica to return a numerical expression from a root expression.";

SinD::usage = "Trigonometric function that takes in degrees.";

CosD::usage = "Trigonometric function that takes in degrees.";

TanD::usage = "Trigonometric function that takes in degrees.";

CotD::usage = "Trigonometric function that takes in degrees.";

SecD::usage = "Trigonometric function that takes in degrees.";

CscD::usage = "Trigonometric function that takes in degrees.";

ArcSinD::usage = "Inverse trigonometric function that outputs in degrees";

ArcCosD::usage = "Inverse trigonometric function that outputs in degrees";

ArcTanD::usage = "Inverse trigonometric function that outputs in degrees";

ArcCotD::usage = "Inverse trigonometric function that outputs in degrees";

ArcSecD::usage = "Inverse trigonometric function that outputs in degrees";

ArcCscD::usage = "Inverse trigonometric function that outputs in degrees";

nCr:: Simplified notation Combinations

nPr:: Simplified notation Permutations


(* ::Section:: *)
(*Begin*)


Begin["`Private`"]


(* ::Section:: *)
(*Definitions*)


(* ::Subsection:: *)
(*Newton*)


(* ::Subsubsection:: *)
(*Newton*)


Newton[fx_, x_, x0_, iter_] :=
DynamicModule[{step = 1, fxInput = "x^2 - 2", xVarStr = "x", xSym, 
  fxParsed, x0 = 1.0, iter = 5, newtonResult = ""}, 
 Dynamic[Panel@
   Column[{Style["Newton's Method Wizard", Bold, 16], 
     Which[step == 1, 
      Column[{Style["Step 1: Enter the function f(x)", Bold], 
        Row[{"f(x): ", InputField[Dynamic[fxInput], String]}], 
        Row[{"Variable: ", InputField[Dynamic[xVarStr], String]}], 
        Button["Next", (Quiet[xSym = ToExpression[xVarStr];
           fxParsed = ToExpression[fxInput];
           step = 2;])]}], step == 2, 
      Column[{Style["Step 2: Initial Guess and Iterations", Bold], 
        Row[{"Initial guess x₀: ", InputField[Dynamic[x0], Number]}], 
        Row[{"Number of iterations: ", 
          InputField[Dynamic[iter], Number]}], 
        Button["Compute", 
         Module[{f, df, current, rows, tangent, intercept}, 
          f[y_] := fxParsed /. {xSym -> y};
          df[y_] := D[fxParsed, xSym] /. {xSym -> y};
          current = x0;
          rows = {{"x", "Tangent Line", "Intercept"}};
          Do[tangent = TangentLine[f[x], x, current, y];
           intercept = current - f[current]/df[current];
           AppendTo[rows, {current, tangent, intercept}];
           current = intercept;, {i, iter}];
          newtonResult = Grid[rows, Frame -> All];
          step = 3;]]}], step == 3, 
      Column[{Style["Step 3: Newton Iteration Table", Bold], 
        Dynamic[newtonResult], Button["Start Over", (step = 1)]}]]}]]]



(* ::Subsubsection:: *)
(*Attributes and Options*)


(* ::Subsection:: *)
(*Euler*)


(* ::Subsubsection:: *)
(*Euler*)


Euler[] :=
DynamicModule[{step = 1, fInput = "x + y", varx = "x", vary = "y", 
  xo = 0, yo = 1, h = 0.1, xF = 1, eulerResult = "", parsedF, xSym, 
  ySym}, Dynamic[
  Panel@Column[{Style["Euler's Method Wizard", Bold, 16], 
     Which[step == 1, 
      Column[{Style["Step 1: Enter the function f(x, y)", Bold], 
        Row[{"f(x, y): ", InputField[Dynamic[fInput], String]}], 
        Row[{"Variable for x: ", InputField[Dynamic[varx], String]}], 
        Row[{"Variable for y: ", InputField[Dynamic[vary], String]}], 
        Button["Next", (xSym = ToExpression[varx];
          ySym = ToExpression[vary];
          parsedF = ToExpression[fInput];
          step = 2;)]}], step == 2, 
      Column[{Style["Step 2: Enter Initial Conditions", Bold], 
        Row[{"x₀: ", InputField[Dynamic[xo], Number]}], 
        Row[{"y₀: ", InputField[Dynamic[yo], Number]}], 
        Row[{"Step size h: ", InputField[Dynamic[h], Number]}], 
        Row[{"Final x value: ", InputField[Dynamic[xF], Number]}], 
        Button["Compute", (eulerResult = 
           TableForm@
            Join[{{varx, vary}}, 
             NestWhileList[
              Function[pt, 
               pt + {h, 
                 h*Evaluate[
                   parsedF /. {xSym -> pt[[1]], 
                    ySym -> pt[[2]]}]}], {xo, yo}, 
              If[h > 0, #[[1]] < xF &, #[[1]] > xF &]]];
          step = 3;)]}], step == 3, 
      Column[{Style["Step 3: Euler Result Table", Bold], 
        Dynamic[eulerResult], Button["Start Over", (step = 1)]}]]}]]]


(* ::Subsubsection:: *)
(*Attributes and Options*)


(* ::Subsection:: *)
(*FindRoots*)


(* ::Subsubsection:: *)
(*FindRoots*)


FindRoots[fun_, {var_, min_, max_}, opts : OptionsPattern[]] :=
    Module[{PlotRules, RootRules, g, g2, pts, pts2, lpts, F, sol, refun
        },
        refun = Refine[fun, min <= var <= max];
        (*Extract the Options*)PlotRules = Sequence @@ FilterRules[Join[
            {opts}, Options @ FindRoots], Options @ Plot];
        RootRules = Sequence @@ FilterRules[Join[{opts}, Options @ FindRoots
            ], Options @ FindRoot];
        (*Plot the function and "mesh" the point with y-coordinate 0*)
            
        g = Normal @ Plot[refun, {var, min, max}, MeshFunctions -> (#2&
            ), Mesh -> {{0}}, Method -> Automatic, Evaluate @ PlotRules];
        (*Get the meshes zeros*)pts = Cases[g, Point[p_] :> SetPrecision[
            p[[1]], OptionValue @ WorkingPrecision], Infinity];
        (*Get all plot points*)lpts = Join @@ Cases[g, Line[p_] :> SetPrecision[
            p, OptionValue @ WorkingPrecision], Infinity];
        (*Derive the interpolated data to find other zeros*)F = Interpolation[
            lpts, InterpolationOrder -> 2];
        g2 = Normal @ Plot[Evaluate @ D[F @ var, var], {var, min, max
            }, MeshFunctions -> (#2&), Mesh -> {{0}}, Method -> Automatic, Evaluate
             @ PlotRules];
        (*Get the meshes zeros and retain only small ones*)pts2 = Cases[
            g2, Point[p_] :> SetPrecision[p[[1]], OptionValue @ WorkingPrecision],
             Infinity];
        pts2 = Select[pts2, Abs[F @ #] < OptionValue @ ZeroTolerance&
            ];
        pts = Join[pts, pts2]; (*Join all zeros*)        (*Refine zeros
            
            
            
             by passing
             each point through FindRoot*)If[Length @ pts > 0,
            pts = Map[FindRoot[refun, {var, #}, Evaluate @ RootRules]&,
                 pts];
            sol = Union @ Select[pts, min <= Last @ Last @ # <= max&]
                ;
            (*For debug purposes*) If[OptionValue @ Debug,
                Print @ Show[g, Graphics @ {PointSize @ 0.02, Red, Point[
                    {var, refun} /. sol]}]
            ];
            sol
            ,
            If[OptionValue @ Debug,
                Print @ g
            ];
            {}
        ]
    ]


(* ::Subsubsection:: *)
(*Attributes and Options*)


Options @ FindRoots = Sort @ Join[Options @ FindRoot, {MaxRecursion ->
     Automatic, PerformanceGoal :> $PerformanceGoal, PlotPoints -> Automatic,
     Debug -> False, ZeroTolerance -> 10 ^ -2}];


(* ::Subsection:: *)
(*ForceSolve*)


(* ::Subsubsection:: *)
(*ForceSolve*)


ForceSolve[stuff_, variables_, domain___] :=
    Module[{b, c, num, result, onetwo, a, r, numq},
        onetwo =
            If[Length[variables] == 2,
                All
                ,
                1
            ];
        a = Check[TimeConstrained[Solve[stuff, variables, domain], 4],
             "Fail"];
        If[a == {{}} \[Or] a === "Fail",
            Return[{}]
        ];
        If[a === $Aborted,
            result = NSolve[stuff, variables, Reals];
            result = ToRadicals[result];
            result = result[[All, onetwo, 2]];
            num = ContainsAny[Head /@ #, {Root, ProductLog, Complex}]&
                 /@ (Flatten /@ (Level[#, -1]& /@ (FullForm /@ result)));
            r = Table[Depth[result[[i]]] > 6, {i, 1, Length[result]}]
                ;
            numq = Thread[num \[Or] r];
            b =
                Table[
                    If[numq[[i]],
                        N[result[[i]]]
                        ,
                        result[[i]]
                    ]
                    ,
                    {i, 1, Length[result]}
                ];
            Chop /@ b
            ,
            result = ToRadicals[a];
            result = result[[All, onetwo, 2]];
            num = ContainsAny[Head /@ #, {Root, ProductLog, Complex}]&
                 /@ (Flatten /@ (Level[#, -1]& /@ (FullForm /@ result)));
            r = Table[Depth[result[[i]]] > 6, {i, 1, Length[result]}]
                ;
            numq = Thread[num \[Or] r];
            b =
                Table[
                    If[numq[[i]],
                        N[result[[i]]]
                        ,
                        result[[i]]
                    ]
                    ,
                    {i, 1, Length[result]}
                ];
            ToRadicals /@ FullSimplify /@ Chop /@ b
        ]
    ]


(* ::Subsubsection:: *)
(*Attributes and Options*)


(* ::Subsection:: *)
(*TrigD*)


SinD[x_] :=
    Sin[x \[Degree]];

CosD[x_] :=
    Cos[x \[Degree]];

TanD[x_] :=
    Tan[x \[Degree]];

CotD[x_] :=
    Cot[x \[Degree]];

SecD[x_] :=
    Sec[x \[Degree]];

CscD[x_] :=
    Csc[x \[Degree]];

ArcTanD[d_] :=
    FullSimplify @ (ArcTan[d] / \[Degree]);

ArcCosD[d_] :=
    FullSimplify @ (ArcCos[d] / \[Degree]);

ArcSinD[d_] :=
    FullSimplify @ (ArcSin[d] / \[Degree]);

ArcSecD[d_] :=
    FullSimplify @ (ArcSec[d] / \[Degree]);

ArcCscD[d_] :=
    FullSimplify @ (ArcCsc[d] / \[Degree]);

ArcCotD[d_] :=
    FullSimplify @ (ArcCot[d] / \[Degree]);


(* ::Subsubsection:: *)
(*Attributes and Options*)


(* ::Subsection:: *)
(*Combinatorics*)

nCr[n_,r_] :=
    FullSimplify @ ((n!)/(r!(n-r)!));

nPr[n_,r_] :=
    FullSimplify @ ((n!)/((n-r)!));


(* ::Section:: *)
(*End*)





End[]
