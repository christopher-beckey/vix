unit SharedGlobals;

interface

   type attachableComponent = record
       displayName: String;
       programID: String;
   end;

   const aa: attachableComponent =
        (displayName: 'ABIC'; programID: 'GearABIC.IGABIC.15');

   const attachableComponents: array [0..15] of attachableComponent =
        ((displayName: 'ABIC'; programID: 'GearABIC.IGABIC.15'),                         // 0
         (displayName: 'ART'; programID: 'GearArt.IGArtCtl.15'),                         // 1
         (displayName: 'ArtX'; programID: 'GearArtX.IGArtXCtl.15'),                      // 2
         (displayName: 'CAD'; programID: 'GearCAD.IGCAD.15'),                            // 3
         (displayName: 'DGN'; programID: 'GearDGN.IGDGN.15'),                            // 4
         (displayName: 'CGM'; programID: 'GearCGM.IGCGM.15'),                            // 5
         (displayName: 'FPX'; programID: 'GearFPX.IGFPX.15'),                            // 6
         (displayName: 'LZW'; programID: 'GearLZW.IGLZW.15'),                            // 7
         (displayName: 'HPGL'; programID: 'GearHPGL.IGHPGL.15'),                         // 8
         (displayName: 'JPEG2K'; programID: 'GearJPEG2K.IGJPEG2K.15'),                   // 9
         (displayName: 'JBIG2'; programID: 'GearJBIG2.IGJBIG2.15'),                      // 10
         (displayName: 'MED'; programID: 'GearMed.IGMedCtl.15'),                         // 11
         (displayName: 'MULTIMEDIA'; programID: 'GearMultimedia.IGMultimedia.15'),       // 12
         (displayName: 'PDF'; programID: 'GearPDF.IGPDFCtl.15'),                         // 13
         (displayName: 'SVG'; programID: 'GearSVG.IGSVG.15'),                            // 14
         (displayName: 'VECTOR'; programID: 'GearVector.IGVectorCtl.15')                 // 15
         );

implementation

end.
