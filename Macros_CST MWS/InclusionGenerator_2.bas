' Creat particles
Option Explicit

Sub Main ()

	With Material
     .Reset
     .Name "BST"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .HeatCapacity "0"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "960"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .EnableUserConstTanDModelOrderEps "False"
     .ConstTanDModelOrderEps "1"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .EnableUserConstTanDModelOrderMu "False"
     .ConstTanDModelOrderMu "1"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NonlinearMeasurementError "1e-1"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

With Material
     .Name "BST"
     .Folder ""
     .Colour "0.752941", "0.752941", "0.752941"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .ChangeColour
End With


Dim i As Long
Dim CoorA() As String
Dim x_cst As Double
Dim y_cst As Double
Dim z_cst As Double
Dim alpha As Double
Dim beta As Double
Dim gamma As Double
Dim Coordinates As String, Text As String, Textline As String
Dim Co As String
Dim rp As Double

rp = 0.12  'y and z axis         <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
StoreParameter("rp",rp)

i = 1

Co = "D:\HPM-NLTL-CST\AR_3.0\CoorFromMatlab\20%_AR_3_#2_0.12_sq.txt"

Open Co For Input As #1
	Do Until EOF(1)
		Line Input #1, Textline
		CoorA = Split(Textline, " ")


		x_cst = CDbl(CoorA(0))
		y_cst = CDbl(CoorA(1))
		z_cst = CDbl(CoorA(2))
		alpha = CDbl(CoorA(3))
		beta = CDbl(CoorA(4))
		gamma = CDbl(CoorA(5))

		StoreParameter("x_cst",x_cst)
		StoreParameter("y_cst",y_cst)
		StoreParameter("z_cst",z_cst)
		StoreParameter("alpha",alpha)
		StoreParameter("beta",beta)
		StoreParameter("gamma",gamma)

		With Sphere                          		'create a sphere, the syntax of defining sphere properties is in History List.
                         .Reset
                         .Name "BST Particle_"+Trim(i)
                         .Component "BST"
                         .Material "BST"
                         .Axis "x"
                         .CenterRadius "rp"
                         .Center x_cst,y_cst,z_cst     'center
                         .Segments "0"
                         .Create
		End With

		With Transform								    'Modify the aspect ratio
					     .Reset
					     .Name "BST:BST Particle_"+Trim(i)
					     .Origin "CommonCenter"
					     .Center "0", "0", "0"
					     .ScaleFactor "3", "1", "1"            'aspect ratio<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					     .MultipleObjects "False"
					     .GroupObjects "False"
					     .Repetitions "1"
					     .MultipleSelection "False"
					     .Transform "Shape", "Scale"
		End With

		 ' --------------Rotation------------

WCS.ActivateWCS "local"

With WCS
     .SetNormal "0", "0", "1"
     .SetOrigin "x_cst","y_cst","z_cst"
     .SetUVector "1", "0", "0"
End With

		With Transform
					     .Reset
					     .Name "BST:BST Particle_"+Trim(i)
					     .Origin "CommonCenter"
					     .Center "0", "0", "0"
					     .Angle "0", "0", "alpha"
					     .MultipleObjects "False"
					     .GroupObjects "False"
					     .Repetitions "1"
					     .MultipleSelection "False"
					     .Transform "Shape", "Rotate"
		End With

WCS.RotateWCS "w", "alpha"

		With Transform
					     .Reset
					     .Name "BST:BST Particle_"+Trim(i)
					     .Origin "CommonCenter"
					     .Center "0", "0", "0"
					     .Angle "0", "beta", "0"
					     .MultipleObjects "False"
					     .GroupObjects "False"
					     .Repetitions "1"
					     .MultipleSelection "False"
					     .Transform "Shape", "Rotate"
		End With

WCS.RotateWCS "v", "beta"

		With Transform
					     .Reset
					     .Name "BST:BST Particle_"+Trim(i)
					     .Origin "CommonCenter"
					     .Center "0", "0", "0"
					     .Angle "gamma", "0", "0"
					     .MultipleObjects "False"
					     .GroupObjects "False"
					     .Repetitions "1"
					     .MultipleSelection "False"
					     .Transform "Shape", "Rotate"
		End With

WCS.AlignWCSWithGlobalCoordinates

		i = i+1

	Loop
Close #1



End Sub


