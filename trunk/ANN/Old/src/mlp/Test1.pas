(*--------------------------------------------------------------------------*
 *   This is a test file to test the nn*.c series with back-propagation.    *
 * This file demonstrates learning of a linear function using 1 input, 1    *
 * output net, with the output node having a linear activation function.    *
 * For this file, the following parameters in the following files should be *
 * set:                                                                     *
 *                                                                          *
 *  Everything else can be left unchanged.  The input files should each     *
 * consist of five real numbers, where they are in matching order of input  *
 * and desired output.  The output of this file simply lists the input,     *
 * weight, output, threshhold, desired output.  It pauses at each training  *
 * epoch.                                                                   *
 *                                                                          *
 *  NOTE: This file does not test the use of testing novel inputs after     *
 * training, and thus does not test InitInPatterns(1) [with parameter 1].   *
 * See nnsim1.c for that.                                                   *
 *--------------------------------------------------------------------------*)
unit Test1;

interface

uses NN;

procedure Main;

implementation

procedure Main;
const
  NUM_ITS = 10;
var
  Pattern: integer;    (* for looping through patterns   *)
  Layer: integer;      (* for looping through layers     *)
  LCV: integer;        (* for looping training sets      *)
  Net: NNETtype;
  InPatterns, OutPattern: PATTERNtype;
begin
  Randomize;
  INPUT_LAYER_SIZE := 1;
  OUTPUT_LAYER_SIZE:= 1;
  NUM_HIDDEN_LAYERS:= 0;
  NUM_PATTERNS     := 5;
  InitNN;
  InitNet(NUMNODES, Net);          (* initializes the network        *)
  InitInPatterns('mlp/test1-in.dat', InPatterns);   (* loads input patterns from file *)
  InitOutPatterns('mlp/test1-ou.dat', OutPattern);     (* loads output patterns from file*)
  for LCV:= 1 to NUM_ITS do begin  (* loop through a training set    *)
    for Pattern:= 0 to NUM_PATTERNS-1 do begin
      (* FORWARD PROPAGATION *)
      UpDateInputAct(InPatterns, Pattern, Net);
      for Layer:= 1 to NUMLAYERS-1 do begin
        UpDateLayerAct(Net, Layer, Net);
      end;
      (* OUTPUT PRINTS *)
      write('Input : ', Net.unt[0,0].state:6:2);
      write(' Weight: ', Net.unt[1,0].weights[0]:6:2);
      write(' Thresh: ', Net.unt[1,0].thresh:6:2);
      write(' Output: ', Net.unt[1,0].state:6:2);
      writeln(' Goal: ', OutPattern.p[Pattern,0]:6:2);
      (* BACKWARD PROPAGATION *)
      UpDateWeightandThresh(Net, OutPattern, Pattern, Net);
    end;
    writeln;
  end;
end;

end.
