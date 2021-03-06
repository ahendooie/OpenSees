# Define a procedure which generates a rectangular reinforced concrete section
# with one layer of steel evenly distributed around the perimeter and a confined core.
# 
#                       y
#                       |
#                       |
#                       |    
#             ---------------------
#             |\                 /|
#             | \---------------/ |
#             | |               | |
#             | |               | |
#  z ---------| |               | |  h
#             | |               | |
#             | |               | |
#             | /---------------\ |
#             |/                 \|
#             ---------------------
#                       b
#
# Formal arguments
#    id - tag for the section that is generated by this procedure
#    h - overall height of the section (see above)
#    b - overall width of the section (see above)
#    cover - thickness of the cover patches
#    coreID - material tag for the core patch
#    coverID - material tag for the cover patches
#    steelID - material tag for the reinforcing steel
#    numBarsTB - number of reinforcing bars top and bottom
#    numBarsS - number of reinforcing bars on sides
#    barArea - cross-sectional area of each reinforcing bar
#    nfCore - number of fibers in the core patch in the y dirn
#    nfCoverS - number of fibers in the side cover
#    nfSCover - number of fibers in the top & bottom cover
#
# Notes
#    The thickness of cover concrete is constant on all sides of the core.
#    The number of bars is the same on any given side of the section.
#    The reinforcing bars are all the same size.
#    The number of fibers in the short direction of the cover patches is set to 1.
# 
proc RCsection2D {id h b cover coreID coverID steelID numBarsTB numBarsS barArea nfCore nfCoverS nfCoverTB} {

   # Define the fiber section

   # some variables derived from the parameters
   set y1 [expr $h/2.0]
   set z1 [expr $b/2.0]
   set As $barArea

   section Fiber 1 {
       # Create the concrete core fibers
       patch rect $coreID $nfCore 1 [expr $cover-$y1] [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover]
       
       # Create the concrete cover fibers (top, bottom, left, right)
       patch rect $coverID $nfCoverS  1     [expr -$y1]    [expr $z1-$cover]     $y1                 $z1
       patch rect $coverID $nfCoverS  1     [expr -$y1]       [expr -$z1]        $y1            [expr $cover-$z1]
       patch rect $coverID $nfCoverTB 1     [expr -$y1]    [expr $cover-$z1] [expr $cover-$y1] [expr $z1-$cover]
       patch rect $coverID $nfCoverTB 1  [expr $y1-$cover] [expr $cover-$z1]      $y1          [expr $z1-$cover]
       
       # Create the reinforcing fibers (left, middle, right)
       layer straight $steelID $numBarsTB  $As [expr $y1-$cover] [expr $z1-$cover] [expr $y1-$cover] [expr $cover-$z1]
       layer straight $steelID $numBarsTB  $As [expr $cover-$y1] [expr $z1-$cover] [expr $cover-$y1] [expr $cover-$z1]
       layer straight $steelID $numBarsS $As [expr $y1-$cover] [expr $z1-$cover] [expr $cover-$y1] [expr $cover-$z1]
       layer straight $steelID $numBarsS $As [expr $y1-$cover] [expr $cover-$z1] [expr $cover-$y1] [expr $z1-$cover]
   }    
}
