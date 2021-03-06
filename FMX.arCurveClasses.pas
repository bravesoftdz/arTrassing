﻿unit FMX.arCurveClasses;

interface

uses System.Classes, System.Generics.Collections, System.Types, System.UITypes, FMX.Types, FMX.Graphics,
     System.SysUtils;

type

 TmarkType=(mpNone,mpCircle,mpUpTriangle,mpTriangle,mpRect,mpRhomb,mpCross,mpDiagCross,mpArrow,mpCustom);
 TTitleType=(ttNone,ttXValue,ttYValue,ttXYvalue,ttTitle,ttDesc,ttCustom);
 /// <summary>
 ///    drawing type of curve class
 /// </summary>
 TcvDrawType=(cdtPolyline,cdtLevels,cdtColumns);
 /// <summary>
 ///        point for Curve with real X,Y coordinates
 /// </summary>
 TcvPoint=Class(TObject)
   private
    function GetPt(Index:integer):single;
    procedure SetPt(Index:integer; Value:single);
   public
    Title,Desc:string;
    Num,Sign,GroupId:integer;
    DataPoint,Point:TPointF;
    /// <summary>
    ///   true=Show Marks (default-true)
    /// </summary>
    Marked:boolean;
    constructor Create(aNum:integer; aDtX,aDtY:single; aGroupId:integer=0);
    function GetAreaRect(aDim:single):TRectF;
    function GetPtAreaRect(aDim:single):TRectF;
    ///
    property X:single  index 1 read GetPt write SetPt;
    property Y:single  index 2 read GetPt write SetPt;
    /// <summary>
    ///       X-ccordinate from Canvas
    /// </summary>
    property ptX:single  index 3 read GetPt write SetPt;
     /// <summary>
    ///       Y-ccordinate from Canvas
    /// </summary>
    property ptY:single  index 4 read GetPt write SetPt;
 End;

TOnPointDrawMarkEvent=procedure(aSndr:TObject; aCv:TCanvas; aIndex:integer; const acvPt:TcvPoint; aFillFlag:boolean) of object;
TOnPointDrawTitleEvent=procedure(aSndr:TObject; aCv:TCanvas; const acvPt:TcvPoint) of object;

TarCurve=Class(TObject)
  private
   FDrawType:TcvDrawType;
   FMarkType:TmarkType;
   FMarkSize:single;
   FmarkVisibled,FmarkFilled:boolean;
   FTitleType:TTitleType;
   FTitleFormatString:String;
   FTitleHorzAlign:TTextAlign;
   FTitleVertAlign:TTextAlign;
   FNum:integer;
   FBrush,FMarkBrush:TStrokeBrush;
   FFill,FMarkFill:TBrush;
   FTitleFont:TFont;
   FTitleColor:TAlphaColor;
   FOpacity,FFillOpacity:single;
   FScalePt:TPointF;
   FActiveArea:TRectF;
   FColumnWidth:single;
   FColumnDividerWidth:single;
   FOnPointDrawMarkEvent:TOnPointDrawMarkEvent;
   FOnPointDrawTitleEvent:TOnPointDrawTitleEvent;
   FEnabled:boolean;
   /// <summary>
   ///    fillBottom - true: DrawPoly with bottom Area
   /// </summary>
   FBottomFilled:boolean;
  protected
    CvRef:TCanvas;
  public
    Points:TObjectList<TcvPoint>;
    constructor Create(aNum:integer; aColor:TAlphaColor; aThickness:single=1;
                       aDash:TStrokeDash=TStrokeDash.Solid; aMarkType:TmarkType=TmarkType.mpNone; aMarkSize:single=4);
    /// <summary>
    ///    setColumnsType Parameters (if aColWidth>aDeltaXX then column width:=Xi+1 - Xi)
    ///   (if aDivWidth>0 then column width:=Xi+1 - Xi - aDivWidth)
    /// </summary>
    procedure SetColumnsType(aColWidth:single; aFillColor:TAlphaColor;
                             aDivWidth:single=0; aColOpacity:single=1; aFillKind:TBrushKind=TBrushKind.Solid);
    procedure SetLevelsType(aFillColor:TAlphaColor; aFillOpacity:single=1; aFillKind:TBrushKind=TBrushKind.Solid);
    destructor Destroy; override;
    /// <summary>
    ///     draw Mark for point
    /// </summary>
    procedure DrawPtMark(aIndex:integer);
    /// <summary>
    ///    hide all marks in points except every aDiv
    /// </summary>
    procedure MarkedEvery(aDivModule:integer);
    /// <summary>
    ///     show (Marks) only Several point from numbers array
    /// </summary>
    procedure MarkedSeveral(const APtNums:array of integer);
    procedure DrawPtMarks;
    /// <summary>
    ///       direct draw curve with current DrawType
    /// </summary>
    procedure DrawPointLines; virtual;
    /// <summary>
    ///   draw Titles for Points with current TitleType
    /// </summary>
    procedure DrawTitles;
    /// <summary>
    ///   calculate curve canvas (pt) Area (min Max X,Y)
    /// </summary>
    function GetAreaRect:TrectF;
    ///
    /// <summary>
    ///    Recalc Canvas Poinnts Data From Regions
    /// </summary>
    procedure ScalePoints(aDataArea,aAreaCvRect:TRectF);
    procedure HideMarksAndTitles(aOnlyTitlesFlag:boolean=false);
  ///
  property DrawType:TcvDrawType read FDrawType;
  /// <summary>
   ///    if BottomFilled=true: DrawPoly with bottom Area - only Polyline DrawType
   /// </summary>
  property BottomFilled:boolean read FBottomFilled write FBottomFilled;
  property Fill:TBrush read FFill;
  property MarkFill:TBrush read FMarkFill;
  property MarkFont:TFont read FTitleFont;
  property TitleColor:TAlphaColor read FTitleColor write FTitleColor;
  property MarkBrush:TStrokeBrush read FMarkBrush;
  property Brush:TStrokeBrush read FBrush;
  property MarkFilled:boolean read FmarkFilled write FmarkFilled;
  property TitleType:TTitleType read FTitleType write FTitleType;
  property TitleFormatString:String read FTitleFormatString write FTitleFormatString;
  property TitleHorzAlign:TTextAlign read FTitleHorzAlign write FTitleHorzAlign;
  property TitleVertAlign:TTextAlign read FTitleVertAlign write FTitleVertAlign;
  property Opacity:single read FOpacity write FOpacity;
  property FillOpacity:single read FFillOpacity write FFillOpacity;
  property MarkType:TmarkType read FMarkType write FMarkType;
  property MarkSize:single read FMarkSize write FMarkSize;
  property OnPointDrawMarkEvent:TOnPointDrawMarkEvent read FOnPointDrawMarkEvent write FOnPointDrawMarkEvent;
  property OnPointDrawTitleEvent:TOnPointDrawTitleEvent read FOnPointDrawTitleEvent write FOnPointDrawTitleEvent;
  property Enabled:boolean read FEnabled write FEnabled;
  property Number:integer read FNum write FNum;
End;

/// <summary>
///   draw Axis Titles - taking into account the space for the axes and rotate Axis
/// </summary>
TarAxisLabel=class(TObject)
  private
   FVerticalFlag:boolean;
   FRect:TRectF;
   FFontColor:TAlphaColor;
   FFont:TFont;
   FText:string;
   FCenter:TPointF;
   FVisible:boolean;
   FbackBrush:TBrush;
   FCanvasRect:TRectF;
  public
    constructor Create(aVerticalFlag:boolean; aColor:TAlphaColor;
                        const aBackColor: TAlphaColor=TAlphaColorrec.Alpha);
    destructor Destroy; override;
    function Draw(const aCV:Tcanvas; const aCvRect:TRectF; aCnX,aCnY:single):boolean;
    ///
    property VerticalFlag:boolean read FVerticalFlag;
    property Font:TFont read FFont;
    property FontColor:TAlphaColor read FFontColor write FFontColor;
    property BackBrush:TBrush read FbackBrush;
    property ClientRect:TRectF read FRect;
    property Text:string read FText write FText;
    property Center:TPointF read FCenter write FCenter;
    property Visible:boolean read FVisible write FVisible;
end;

/// <summary>
///     Axis class - fro draw Axis (X,Y)
/// </summary>
TarAxis=class(TObject)
  private
   FVerticalFlag:boolean;
   FEnabled:boolean;
   FMin,FMax,FInterval,FOrtoValue:single;
   FTitleFont:TFont;
   FTitleVertAlign,FTitleHorzAlign:TTextAlign;
   FTitleColor:TAlphaColor;
   FBrush,FLineBrush:TStrokeBrush;
   FlabelSize:integer;
   FTitleType:TTitleType;
   FTitleFormatString:String;
   FOnPointDrawTitleEvent:TOnPointDrawTitleEvent;
  protected
    CvRef:TCanvas;
    UnionRect:TRectF;
    FTextLabel:TarAxisLabel;
    /// <summary>
    ///    adding - (Rect from Line and labelsSize)
    /// </summary>
    FCanvasRect,FAxisCanvasRect:TRectF;
    procedure SetCanvasRects(const AcvAllRect:TRectF; aCvMin,aCvMax,aCvOrto:single);
  public
    Labels:TObjectList<TcvPoint>;
    function RecalcLabels(apMin, apMax, aInterval,aOrtoValue:single):boolean;
    constructor Create(aVerticalFlag:boolean;
     aColor,aLineColor,aTitleColor:TAlphaColor; aLabSize:integer=4);
    destructor Destroy; override;
   ///
    function DrawLabelsAndLine:boolean;
    function DrawTitles:boolean;
   ///
   property TextLabel:TarAxisLabel read FTextLabel;
   ///
   property Min:single read FMin;
   property Max:single read FMax;
   property Interval:single read FInterval;
   property OrtoValue:single read FOrtoValue;
   property VerticalFlag:boolean read FVerticalFlag;
   property Enabled:boolean read FEnabled;
   property Brush:TStrokeBrush read FBrush;
   property LineBrush:TStrokeBrush read FLineBrush;
   property TitleFont:TFont read FTitleFont;
   property TitleVertAlign:TTextAlign read FTitleVertAlign write FTitleVertAlign;
   property TitleHorzAlign:TTextAlign read FTitleHorzAlign write FTitleHorzAlign;
   property TitleColor:TAlphaColor read FTitleColor write FTitleColor;
   property TitleType:TTitleType read FTitleType write FTitleType;
   property OnPointDrawTitleEvent:TOnPointDrawTitleEvent read FOnPointDrawTitleEvent write FOnPointDrawTitleEvent;
end;

TGridType=(gtNone,gtVertical,gtHorizontal,gtBoth);

TarChartArea=class(TObject)
  private
    FMarginRect:TRectf;
    FDataArea,FCanvasArea:TRectF;
    FXYCoeffs:TPointF;
    FGridBrush,FFrameBrush:TStrokeBrush;
    FBackFill,FFrameFill:TBrush;
    FGridType:TGridType;
    FAxisDivider:TPointF;
  protected
    CvRef:TCanvas;
    F_addAxisMargin,F_addFrameMargin:integer;
  public
    AxisX,AxisY:TarAxis;
    Curves:TobjectList<TarCurve>;
    function GetActiveArea:TRectF;
    procedure SetAreaParams(const aDataArea,aAreaCvRect:TRectF);
    /// <summary>
    ///    с установленными ранее в SetAreaParams значениями перевычислить с новыми границами margins
    /// </summary>
    procedure ResetAreaParams;
    /// <summary>
    ///    изменяется только область canvas - у нее новый размер
    /// </summary>
    procedure ResetCanvasArea(const aAreaCvRect:TRectF);
    /// <summary>
    ///    задать кол-во разбиений по осям XY - перед этим следует задать DataArea
    /// </summary>
    procedure SetAxisDividerValues(adivX,adivY:single);
    procedure SetCanvas(const ACv:Tcanvas);
    function DrawAxes:boolean;
    procedure SetAxisTextLabels(const AXtext,aYtext:string);
    function DrawGrid:boolean;
    /// inner frame
    procedure DrawFrame;
    /// <summary>
    ///    Draw img Bounds rect
    /// </summary>
    procedure DrawBoundsRect(aCL:TAlphaColor=TAlphaColorRec.Darkgray; aThickness:single=0.8);
    ///
    /// <summary>
    ///    service - Create and Add  Curve to Curves
    /// </summary>
    function AddCurve(aNum:integer; aColor:TAlphaColor; aThickness:single=1;
                      aDash:TStrokeDash=TStrokeDash.Solid; aMarkType:TmarkType=TmarkType.mpNone; aMarkSize:single=4):integer;
    ///
    /// <summary>
    ///    Draw one curve from Ref
    /// </summary>
    function DrawCurve(const aCv:TarCurve):boolean;
    function DrawCurves:boolean;
    function GetIndexFromNumber(aNum:integer):integer;
    function GetCurveFromNumber(aNum:integer):TarCurve;
    /// <summary>
    ///    change Curve to Forward (Front)
    /// </summary>
    procedure BringNumToFront(aNum:integer);
    ///
    constructor Create(aFrameColor,aGridColor:TAlphaColor;
                       aGridDash:TStrokeDash=TStrokeDash.Solid; aLabelThickness:single=1);
    destructor Destroy; override;
    ///
    procedure RedrawAll;
    ///
    /// <summary>
    ///    после RedrawAll изменяет отступы с учетом длинны надписей текста осей и + addAxismargin как доп. отступ
    ///    от осей с цифрами и addFrameMargin - от верх и право (где осей нет)
    /// </summary>
    procedure ApplyAutoMargins(addAxisMargin,addFrameMargin:integer);
    /// <summary>
    ///    пересчет автоотступов при изменении размера картинки (не меняется значение отступов - берется предыдущее)
    /// </summary>
    procedure ResetAutoMargins;
    ///
    /// <summary>
    ///    использовать переустановку размеров Bitmap и далее полный цикл вывода
    /// </summary>
    procedure PaintToBitmap(const ABM:TBitmap; aNewBMArea:TRectF; AutoMarginEnabled:boolean=false);
    ///
    property MarginRect:TRectF read FMarginRect;
    property GridBrush:TStrokeBrush read FGridBrush;
    property GridType:TGridType read FGridType write FGridType;
    property BackFill:TBrush read FBackFill;
    property FrameFill:TBrush read FFrameFill;
    property AxisDivider:TPointF read FAxisDivider write FAxisDivider;
end;



implementation

uses System.Math, System.Math.Vectors;

{ TcvPoint }

constructor TcvPoint.Create(aNum:integer; aDtX, aDtY: single; aGroupId:integer=0);
begin
 inherited Create;
 Num:=aNum;
 GroupId:=aGroupId;
 DataPoint:=PointF(aDtX,aDtY);
 Marked:=true;
end;

function TcvPoint.GetPtAreaRect(aDim: single): TRectF;
var LDim:single;
begin
  LDim:=Abs(0.5*ADim);
  if LDim<0.1 then LDim:=0.1;
  Result:=RectF(Point.X-LDim,Point.Y-LDim,Point.X+LDim,Point.Y+LDim);
end;

function TcvPoint.GetAreaRect(aDim: single): TRectF;
var LDim:single;
begin
  LDim:=Abs(ADim);
  Result:=RectF(DataPoint.X-LDim,DataPoint.Y-LDim,DataPoint.X+LDim,DataPoint.Y+LDim);
end;


function TcvPoint.GetPt(Index: integer): single;
begin
 case Index of
  1: Result:=DataPoint.X;
  2: Result:=DataPoint.Y;
  3: Result:=Point.X;
  4: Result:=Point.Y;
  else Result:=0;
 end;
end;

procedure TcvPoint.SetPt(Index: integer; Value: single);
begin
  case Index of
  1: DataPoint.X:=Value;
  2: DataPoint.Y:=Value;
  3: Point.X:=Value;
  4: Point.Y:=Value;
 end;
end;

{ TarCurve }

constructor TarCurve.Create(aNum: integer; aColor: TAlphaColor;
  aThickness: single; aDash:TStrokeDash; aMarkType: TmarkType; aMarkSize:single);
begin
  inherited Create;
  FEnabled:=true; // !
  FOnPointDrawMarkEvent:=nil;
  FOnPointDrawTitleEvent:=nil;
  FDrawType:=cdtPolyline;
  FBottomFilled:=false;
  FTitleType:=ttNone;
  FTitleFormatString:='%.2f';
  FTitleHorzAlign:=TTextAlign.Center;
  FTitleVertAlign:=TTextAlign.Leading;
  FBrush:=TStrokeBrush.Create(TBrushKind.Solid,aColor);
  FBrush.Kind:=TBrushKind.Solid;
  FBrush.Thickness:=aThickness;
  FBrush.Dash:=aDash;
  Points:=TObjectList<TcvPoint>.Create(true);
  FMarkType:=aMarkType;
  FNum:=aNum;
  FOpacity:=1; FFillOpacity:=1;
  FMarkSize:=Abs(aMarkSize);
  FMarkBrush:=TStrokeBrush.Create(TBrushKind.Solid,aColor);
  FFill:=TBrush.Create(TBrushKind.None,aColor);
  FFill.Kind:=TBrushKind.Solid;
  FMarkFill:=TBrush.Create(TBrushKind.None,aColor);
  FMarkFill.Kind:=TBrushKind.Solid;
  FTitleFont:=TFont.Create;
  FTitleFont.Size:=10;
  FTitleColor:=FMarkBrush.Color;
  FActiveArea:=RectF(0,0,100,100);
  FColumnDividerWidth:=0;
  FColumnWidth:=12;
 // FTitleFont.Color:=
end;

destructor TarCurve.Destroy;
begin
  Points.Free;
  FBrush.Free;
  FMarkBrush.free;
  FFill.Free;
  FMarkFill.Free;
  FTitleFont.Free;
  inherited;
end;


procedure TarCurve.DrawPointLines;
var LcvPt:TcvPoint;
    i,j:integer;
    L_minX,L_maxX,L_DivX:single;
    L_A:TPolygon;
    LState:TCanvasSaveState;
    L_Corn:TCorners;
    L_Rect:TRectF;
begin
  if Points.Count=0 then exit;
  i:=0; j:=0;
  case FDrawType of
   cdtPolyline:
       begin
         if (FBottomFilled=true) then
             SetLength(L_A,Points.Count+2)
         else
             SetLength(L_A,Points.Count);
         for LcvPt in Points do
            begin
              L_A[i]:=LcvPt.Point;
              Inc(i);
            end;
       end;
   cdtLevels:
       begin
         if (FBottomFilled=true) then
             SetLength(L_A,2*Points.Count+2)
         else SetLength(L_A,2*Points.Count);
         j:=Length(L_A);
         j:=0;
         while j<Points.Count do
            begin
              LcvPt:=Points.Items[j];
              if (j<Points.Count-1) then
               begin
                L_A[i]:=LcvPt.Point;
                L_A[i+1]:=PointF(Points.Items[j+1].ptX,L_A[i].Y);
                Inc(i,2);
               end
              else
               begin
                L_A[i]:=LcvPt.Point;
                if L_A[i].X<FActiveArea.Right then
                   L_A[i+1]:=PointF(FActiveArea.Right,LcvPt.ptY)
                else L_A[i+1]:=L_A[i];
                Inc(i,2);
               end;
             Inc(j);
            end;
       end;
  end;
  if (FBottomFilled=true) and (i>1) and (i<High(L_A)) and (FDrawType<>cdtColumns) then
    begin
      L_A[i]:=PointF(L_A[i-1].X,FActiveArea.Bottom);
      L_A[i+1]:=PointF(FActiveArea.Left,FActiveArea.Bottom);
    end;
  if Length(L_A)=0 then exit;
  ///
  case FDrawType of
    cdtPolyline,cdtLevels:
         with CvRef do
          begin
           LState:=SaveState;
           try
            IntersectClipRect(FActiveArea);
            Stroke.Assign(FBrush);
            CvRef.Fill.Assign(FFill);
            if FBottomFilled then
             begin
              FillPolygon(L_A,FFillOpacity);
              DrawPolygon(L_A,FOpacity);
             end
            else
              for i:=Low(L_A) to High(L_A)-1 do
                  DrawLine(L_A[i],L_A[i+1],FOpacity);
           finally
            RestoreState(LState);
           end;
          end;
    cdtColumns:
      begin
        L_DivX:=0.5*Abs(FColumnDividerWidth);
        L_Corn:=[];// [TCorner.TopLeft,TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
        with CvRef do
          begin
           LState:=SaveState;
           try
            IntersectClipRect(FActiveArea);
            Stroke.Assign(FBrush);
            for i:=0 to High(L_A) do
               begin
                if (i>0) then
                      L_minX:=L_A[i-1].X+0.5*Abs(L_A[i].X-L_A[i-1].X)+L_DivX
                else L_minX:=FActiveArea.Left+L_DivX;
                if (i<High(L_A)) then
                      L_maxX:=L_A[i+1].X-0.5*Abs(L_A[i+1].X-L_A[i].X)-L_DivX
                else L_maxX:=FActiveArea.Right-L_DivX;
                ///
                if FColumnWidth>0 then
                 begin
                   L_Rect:=RectF(L_A[i].X-0.5*FColumnWidth,L_A[i].Y,L_A[i].X+0.5*FColumnWidth,FActiveArea.Bottom);
                   /// calculate Xi+1 - Xi delta
                   if L_Rect.Left<L_minX then L_Rect.Left:=L_minX;
                   if L_Rect.Right>L_maxX then L_Rect.Right:=L_maxX;
                 end
                else
                  begin
                    L_Rect:=RectF(L_minX,L_A[i].Y,L_maxX,FActiveArea.Bottom);
                  end;
                 ///
                 FillRect(L_Rect,0,0,[],FFillOpacity,FFill,TCornerType.InnerLine);
                 DrawRect(L_Rect,0,0,L_Corn,FOpacity,FBrush,TCornerType.Bevel);
               end;
           finally
            RestoreState(LState);
           end;
          end;
      end;
  end;
  SetLength(L_A,0);
end;

procedure TarCurve.DrawPtMark(aIndex: integer);
var Lpt:TcvPoint;
    Lpg:TPolygon;
    L_Rad,L_cr:single;
    L_Corn:TCorners;
    L_Rect:TRectF;
begin
  Lpt:=Points.Items[aIndex];
  if (FMarkType<>TmarkType.mpNone) and (Lpt.Marked=true) then
    with CvRef do
     begin
      L_Rect:=FActiveArea;
      L_Rect.Inflate(1,1);
      if (Assigned(Lpt)=false) or (PtInRect(L_rect,Lpt.Point)=false) then exit;
      L_Rad:=0.5*FMarkSize;
      L_cr:=0.1*FMarkSize;
      Stroke.Assign(FMarkBrush);
      Fill.Assign(FMarkFill);
      Font.Assign(FTitleFont);
      L_Corn:=[TCorner.TopLeft,TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
      ///
      if FmarkFilled=false then
        case FMarkType of
          mpCircle: DrawEllipse(Lpt.GetPtAreaRect(FMarkSize),FOpacity,FMarkBrush);
          mpUpTriangle:
           DrawPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY-L_Rad),PointF(Lpt.ptX+L_Rad,Lpt.ptY-L_Rad),PointF(Lpt.ptX,Lpt.ptY+L_Rad)],FOpacity);
          mpTriangle:
           DrawPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY+L_Rad),PointF(Lpt.ptX+L_Rad,Lpt.ptY+L_Rad),PointF(Lpt.ptX,Lpt.ptY-L_Rad)],FOpacity);
          mpRect: if FMarkSize<6 then
                      DrawRect(Lpt.GetPtAreaRect(FMarkSize),0,0,[], FOpacity,FMarkBrush,TCornerType.Bevel)
                  else
                      DrawRect(Lpt.GetPtAreaRect(FMarkSize),1,1,L_Corn, FOpacity,FMarkBrush,TCornerType.Round);
          mpRhomb:
           DrawPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY),
                        PointF(Lpt.ptX,Lpt.ptY-L_Rad),
                        PointF(Lpt.ptX+L_Rad,Lpt.ptY),
                        PointF(Lpt.ptX,Lpt.ptY+L_Rad)],FOpacity);

      mpCross: DrawPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY+L_cr),
                              PointF(Lpt.ptX-L_Rad,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY-L_Rad),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY-L_Rad),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX+L_Rad,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX+L_Rad,Lpt.ptY+L_cr),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY+L_cr),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY+L_Rad),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY+L_Rad),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY+L_cr)],FOpacity);
      mpDiagCross: DrawPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY-L_Rad+L_cr),
                                PointF(Lpt.ptX-L_Rad+L_cr,Lpt.ptY-L_Rad),
                                PointF(Lpt.ptX,Lpt.ptY-L_cr),
                                PointF(Lpt.ptX+L_Rad-L_cr,Lpt.ptY-L_Rad),
                                PointF(Lpt.ptX+L_Rad,Lpt.ptY-L_Rad+L_cr),
                                PointF(Lpt.ptX+L_cr,Lpt.ptY),
                                PointF(Lpt.ptX+L_Rad,Lpt.ptY+L_Rad-L_cr),
                                PointF(Lpt.ptX+L_Rad-L_cr,Lpt.ptY+L_Rad),
                                PointF(Lpt.ptX,Lpt.ptY+L_cr),
                                PointF(Lpt.ptX-L_Rad+L_cr,Lpt.ptY+L_Rad),
                                PointF(Lpt.ptX-L_Rad,Lpt.ptY+L_Rad-L_cr),
                                PointF(Lpt.ptX-L_cr,Lpt.ptY)],FOpacity);
      mpArrow:    DrawPolygon([PointF(Lpt.ptX-L_cr,Lpt.ptY-2*L_Rad),
                               PointF(Lpt.ptX+L_cr,Lpt.ptY-2*L_Rad),
                               PointF(Lpt.ptX+L_cr,Lpt.ptY-1.5*L_rad+L_cr),
                               PointF(Lpt.ptX+L_Rad,Lpt.ptY-1.5*L_Rad),
                               PointF(Lpt.ptX,Lpt.ptY),
                               PointF(Lpt.ptX-L_Rad,Lpt.ptY-1.5*L_Rad),
                               PointF(Lpt.ptX-L_cr,Lpt.ptY-1.5*L_rad+L_cr)],FOpacity);
      mpCustom:  begin
                    if Assigned(FOnPointDrawMarkEvent) then
                       FOnPointDrawMarkEvent(Self,CvRef,aIndex,Lpt,false);
                 end;
       end { case }
      else
       case FMarkType of
          mpCircle: FillEllipse(Lpt.GetPtAreaRect(FMarkSize),FOpacity,FMarkBrush);
          mpUpTriangle:
           FillPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY-L_Rad),PointF(Lpt.ptX+L_Rad,Lpt.ptY-L_Rad),PointF(Lpt.ptX,Lpt.ptY+L_Rad)],FOpacity);
          mpTriangle:
           FillPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY+L_Rad),PointF(Lpt.ptX+L_Rad,Lpt.ptY+L_Rad),PointF(Lpt.ptX,Lpt.ptY-L_Rad)],FOpacity);
          mpRect: if FMarkSize<6 then
                      FillRect(Lpt.GetPtAreaRect(FMarkSize),0,0,[], FOpacity,FMarkBrush,TCornerType.Bevel)
                  else
                      FillRect(Lpt.GetPtAreaRect(FMarkSize),1,1,L_Corn, FOpacity,FMarkBrush,TCornerType.Round);
          mpRhomb:
           FillPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY),
                        PointF(Lpt.ptX,Lpt.ptY-L_Rad),
                        PointF(Lpt.ptX+L_Rad,Lpt.ptY),
                        PointF(Lpt.ptX,Lpt.ptY+L_Rad)],FOpacity);

      mpCross: FillPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY+L_cr),
                              PointF(Lpt.ptX-L_Rad,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY-L_Rad),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY-L_Rad),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX+L_Rad,Lpt.ptY-L_cr),
                              PointF(Lpt.ptX+L_Rad,Lpt.ptY+L_cr),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY+L_cr),
                              PointF(Lpt.ptX+L_cr,Lpt.ptY+L_Rad),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY+L_Rad),
                              PointF(Lpt.ptX-L_cr,Lpt.ptY+L_cr)],FOpacity);
      mpDiagCross: FillPolygon([PointF(Lpt.ptX-L_Rad,Lpt.ptY-L_Rad+L_cr),
                                PointF(Lpt.ptX-L_Rad+L_cr,Lpt.ptY-L_Rad),
                                PointF(Lpt.ptX,Lpt.ptY-L_cr),
                                PointF(Lpt.ptX+L_Rad-L_cr,Lpt.ptY-L_Rad),
                                PointF(Lpt.ptX+L_Rad,Lpt.ptY-L_Rad+L_cr),
                                PointF(Lpt.ptX+L_cr,Lpt.ptY),
                                PointF(Lpt.ptX+L_Rad,Lpt.ptY+L_Rad-L_cr),
                                PointF(Lpt.ptX+L_Rad-L_cr,Lpt.ptY+L_Rad),
                                PointF(Lpt.ptX,Lpt.ptY+L_cr),
                                PointF(Lpt.ptX-L_Rad+L_cr,Lpt.ptY+L_Rad),
                                PointF(Lpt.ptX-L_Rad,Lpt.ptY+L_Rad-L_cr),
                                PointF(Lpt.ptX-L_cr,Lpt.ptY)],FOpacity);
      mpArrow:    FillPolygon([PointF(Lpt.ptX-L_cr,Lpt.ptY-2*L_Rad),
                               PointF(Lpt.ptX+L_cr,Lpt.ptY-2*L_Rad),
                               PointF(Lpt.ptX+L_cr,Lpt.ptY-1.5*L_rad+L_cr),
                               PointF(Lpt.ptX+L_Rad,Lpt.ptY-1.5*L_Rad),
                               PointF(Lpt.ptX,Lpt.ptY),
                               PointF(Lpt.ptX-L_Rad,Lpt.ptY-1.5*L_Rad),
                               PointF(Lpt.ptX-L_cr,Lpt.ptY-1.5*L_rad+L_cr)],FOpacity);
      mpCustom:  begin
                   if Assigned(FOnPointDrawMarkEvent) then
                       FOnPointDrawMarkEvent(Self,CvRef,aIndex,Lpt,true);
                 end;

      end;
     end;
end;

procedure TarCurve.DrawPtMarks;
var i:integer;
begin
  i:=0;
  while i<Points.Count do
    begin
      DrawPtMark(i);
      Inc(i);
    end;
end;

procedure TarCurve.DrawTitles;
var LPt:TcvPoint;
    i:integer;
    L_Title:String;
    Lx,Ly,L_Rad,LW,LH:single;
    L_Rect,L_AreaRect:TRectf;
begin
  if (Points.Count=0) or (FTitleType=ttNone) then exit;
  with CvRef do
   begin
    Font.Assign(FTitleFont);
    Fill.Color:=FTitleColor;
    L_Rad:=0.5*FMarkSize;
    for Lpt in Points do
     begin
          L_Title:='';
          if Lpt.Marked=true then
              case FTitleType of
                ttXValue: if FTitleFormatString='*' then
                             L_Title:=FloatToStr(Lpt.X)
                          else L_Title:=Format(FTitleFormatString,[Lpt.x]);
                ttYValue: if FTitleFormatString='*' then
                             L_Title:=FloatToStr(Lpt.Y)
                          else L_Title:=Format(FTitleFormatString,[Lpt.Y]);
                ttXYvalue: if FTitleFormatString='*' then
                              L_Title:=Format('%f,%f',[Lpt.X,Lpt.Y])
                           else
                              L_Title:=Format(FTitleFormatString+'.'+FTitleFormatString,[Lpt.X,Lpt.Y]);
                ttTitle: L_Title:=Lpt.Title;
                ttDesc: L_Title:=Lpt.Desc;
                ttCustom:
                   begin
                     if Assigned(FOnPointDrawTitleEvent) then
                               FOnPointDrawTitleEvent(Self,CvRef,Lpt);
                   end;
               end;
        L_AreaRect:=FActiveArea; //!
        L_AreaRect.Inflate(1,1);
        if (L_Title<>'') and (FTitleType<>ttCustom) and (PtInRect(L_AreaRect,Lpt.Point)=true) then
         begin
           Lx:=LPt.ptX;
           LH:=TextHeight(L_Title);
           LW:=TextWidth(L_Title);
           case FTitleVertAlign of
            TTextAlign.Center:  Ly:=LPt.ptY;
            TTextAlign.Leading: if FMarkType=mpNone then
                                   Ly:=LPt.ptY-LH-L_Rad
                                else
                                   Ly:=LPt.ptY-LH-L_Rad-FMarkSize-1;
            TTextAlign.Trailing: Ly:=LPt.ptY+LH+L_Rad;
           end;
           case FTitleHorzAlign of
            TTextAlign.Center:  L_Rect:=RectF(Lx-L_rad-0.5*LW,Ly,Lx+L_rad+0.5*LW,LPt.ptY);
            TTextAlign.Leading: L_Rect:=RectF(Lx-LW-L_Rad,Ly,Lx-L_rad,LPt.ptY);
            TTextAlign.Trailing: L_Rect:=RectF(Lx+L_Rad,Ly,Lx+LW+L_Rad,LPt.ptY);
           end;
           FillText(L_Rect,L_Title,False,FOpacity,[],TTextAlign.Center,TTextAlign.Center);
         end;
    end;
   end;
end;

function TarCurve.GetAreaRect: TrectF;
var LxMin,LXMax,LYMin,Lymax:single;
    Lpt:TcvPoint;
begin
  LxMax:=-1e38; LxMin:=1e38;
  LyMax:=-1e38; LyMin:=1e38;
  for Lpt in Points do
     begin
       if Lpt.X>LXMax then
          LXMax:=Lpt.X;
       if Lpt.X<LXMin then
          LXMin:=Lpt.X;
       if Lpt.Y>LYMax then
          LYMax:=Lpt.Y;
       if Lpt.Y<LYMin then
          LYMin:=Lpt.Y;
     end;
  Result:=RectF(LxMin,LYMin,LXMax,Lymax);
end;

procedure TarCurve.HideMarksAndTitles(aOnlyTitlesFlag:boolean=false);
var Lpt:TcvPoint;
begin
  if aOnlyTitlesFlag then
     FTitleType:=ttNone
  else
    for Lpt in Points do
        Lpt.Marked:=false;
end;

procedure TarCurve.MarkedEvery(aDivModule: integer);
var Lpt:TcvPoint;
    i:integer;
begin
 i:=0;
 while i<Points.Count do
    begin
      Lpt:=Points[i];
      if (Lpt=Points.First) then //or (Lpt=Points.Last) then
         Lpt.Marked:=true
      else
          Lpt.Marked:=(((i+1) mod Abs(aDivModule))=0);
     Inc(i);
    end;
end;

procedure TarCurve.MarkedSeveral(const APtNums: array of integer);
var Lpt:TcvPoint;
    i:integer;
begin
  for Lpt in Points do
   for i:=Low(APtNums) to High(APtNums) do
       if Lpt.Num=APtNums[i] then
          Lpt.Marked:=true;
end;

procedure TarCurve.ScalePoints(aDataArea,aAreaCvRect:TRectF);
var Lrect:Trectf;
    Lpt:TcvPoint;
begin
  LRect:=RectF(0,0,aDataArea.Right-aDataArea.Left,aDataArea.Bottom-aDataArea.Top);
  FScalePt:=PointF(0,0);
  if (Lrect.Width>0) and (LRect.Height>0) then
       FScalePt:=PointF(aAreaCvRect.Width/Lrect.Width,aAreaCvRect.Height/LRect.Height);
  for Lpt in Points do
    begin
      Lpt.Point:=PointF(aAreaCvRect.Left+(Lpt.DataPoint.X-aDataArea.Left)*FScalePt.X,
                        aAreaCvRect.Bottom-(Lpt.DataPoint.Y-aDataArea.Top)*FScalePt.Y);
      Lpt.Title:='';
    end;
  FActiveArea:=aAreaCvRect; // !
end;

procedure TarCurve.SetColumnsType(aColWidth:single; aFillColor:TAlphaColor; aDivWidth:single=0;
                 aColOpacity:single=1; aFillKind:TBrushKind=TBrushKind.Solid);
begin
  FDrawType:=cdtColumns;
  FColumnWidth:=aColWidth;
  FFill.Kind:=aFillKind;
  FFill.Color:=aFillColor;
  FFillOpacity:=aColOpacity;
  FColumnDividerWidth:=aDivWidth;
end;

procedure TarCurve.SetLevelsType(aFillColor: TAlphaColor; aFillOpacity: single;
  aFillKind: TBrushKind);
begin
  FDrawType:=cdtLevels;
  FFill.Kind:=aFillKind;
  FFill.Color:=aFillColor;
  FFillOpacity:=aFillOpacity;
end;

{ TarAxis }

constructor TarAxis.Create(aVerticalFlag: boolean;
                             aColor,aLineColor,aTitleColor:TAlphaColor; aLabSize:integer=4);
begin
  inherited Create;
  FEnabled:=false;
  FInterval:=0.1;
  Fmin:=0;
  Fmax:=1;
  FCanvasRect:=Rect(0,0,0,0);
  FAxisCanvasRect:=FCanvasRect;
  FOnPointDrawTitleEvent:=nil;
  FVerticalFlag:=aVerticalFlag;
  ///
   FTitleFont:=TFont.Create;
   FTitleFont.Size:=11;
   if FVerticalFlag then
    begin
      FTitleVertAlign:=TTextAlign.Center;
      FTitleHorzAlign:=TTextAlign.Leading;
      FTitleType:=ttYValue;
    end
   else
    begin
      FTitleVertAlign:=TTextAlign.Trailing;
      FTitleHorzAlign:=TTextAlign.Center;
      FTitleType:=ttXValue;
    end;
   FTitleFormatString:='*'; // %.3f
   FTitleColor:=aTitleColor;// TAlphaColorRec.Black;
   FBrush:=TStrokeBrush.Create(TBrushKind.Solid,aColor);
   FLineBrush:=TStrokeBrush.Create(TBrushKind.Solid,aLineColor);
   FLineBrush.Thickness:=1.5;
   FlabelSize:=aLabSize;
  ///
  Labels:=TObjectList<TcvPoint>.Create(true);
  UnionRect:=RectF(0,0,0,0);
 //// RecalcLabels(apMin,apMax,aInterval,aOrtoValue);
  FTextLabel:=TarAxisLabel.Create(FVerticalFlag,aTitleColor);
end;


destructor TarAxis.Destroy;
begin
  FTextLabel.Free;
  FTitleFont.Free;
  FBrush.Free;
  FLineBrush.free;
  Labels.Free;
  inherited;
end;

function TarAxis.DrawLabelsAndLine: boolean;
var Lpt:TcvPoint;
begin
  Result:=false;
  if (FEnabled=false) or (Labels.Count=0) then exit;
  with CvRef do
   if FVerticalFlag then
    begin
        for Lpt in Labels do
            DrawLine(PointF(Lpt.Point.X-FlabelSize,Lpt.Point.Y),Lpt.Point,1,FBrush);
        DrawLine(Labels.First.Point,Labels.Last.Point,1,FLineBrush);
        Result:=true;
    end
   else
      begin
         for Lpt in Labels do
            DrawLine(Lpt.Point,PointF(Lpt.Point.X,Lpt.Point.Y+FlabelSize),1,FBrush);
        DrawLine(Labels.First.Point,Labels.Last.Point,1,FLineBrush);
        Result:=true;
      end;
end;

function TarAxis.DrawTitles: boolean;
var Lpt:TcvPoint;
    L_Rect:TRectF;
    L_Title:String;
    LW,LH:single;
    LUnFlag:boolean;
begin
  Result:=false;
  if (FEnabled=false) or (Labels.Count=0) then exit;
  with CvRef do
   begin
     LUnFlag:=false;
     Font.Assign(FTitleFont);
     Fill.Color:=FTitleColor;
     for Lpt in Labels do
      begin
          L_Title:='';
          case FTitleType of
            ttXValue: if FTitleFormatString='*' then
                         L_Title:=FloatToStr(Lpt.X)
                      else L_Title:=Format(FTitleFormatString,[Lpt.X]);
            ttYValue: if FTitleFormatString='*' then
                         L_Title:=FloatToStr(Lpt.Y)
                      else L_Title:=Format(FTitleFormatString,[Lpt.Y]);
            ttXYvalue: if FTitleFormatString='*' then
                          L_Title:=Format('%f,%f',[Lpt.X,Lpt.Y])
                       else
                           L_Title:=Format(FTitleFormatString+','+FTitleFormatString,[Lpt.X,Lpt.Y]);
            ttTitle: L_Title:=Lpt.Title;
            ttDesc: L_Title:=Lpt.Desc;
            ttCustom:
               begin
                 if Assigned(FOnPointDrawTitleEvent) then
                           FOnPointDrawTitleEvent(Self,CvRef,Lpt);
               end;
          end;

        if (L_Title<>'') and (FTitleType<>ttCustom) then
         begin
           LH:=TextHeight(L_Title);
           LW:=TextWidth(L_Title);
           if FVerticalFlag then
             begin
               L_Rect:=RectF(Lpt.ptX-LW-2-FlabelSize,Lpt.ptY-0.5*LH,Lpt.ptX-2-FlabelSize,Lpt.ptY+0.5*LH);
             end
           else
             begin
               L_Rect:=RectF(Lpt.ptX-0.5*LW,Lpt.ptY+1+FlabelSize,Lpt.ptX+0.5*LW,Lpt.ptY+1+FlabelSize+LH);
             end;
           if LUnFlag=false then
            begin
              UnionRect:=L_Rect;
              LUnFlag:=true;
            end
           else
             begin
               if L_Rect.Left<UnionRect.Left then
                  UnionRect.Left:=L_Rect.Left;
               if L_Rect.Top<UnionRect.Top then
                  UnionRect.Top:=L_Rect.Top;
               if L_Rect.Right>UnionRect.Right then
                  UnionRect.Right:=L_Rect.Right;
               if L_Rect.Bottom>UnionRect.Bottom then
                  UnionRect.Bottom:=L_Rect.Bottom;
             end;
           FillText(L_Rect,L_Title,False,1,[],TTextAlign.Center,TTextAlign.Center);
           Result:=true;
         end;
      end;
     // TextLabels:
     if FVerticalFlag then
        FTextLabel.Draw(CvRef,FCanvasRect,UnionRect.Left,FAxisCanvasRect.Top+Abs(0.5*FAxisCanvasRect.Height))
     else
        FTextLabel.Draw(CvRef,FCanvasRect,FAxisCanvasRect.Left+Abs(0.5*FAxisCanvasRect.Width),UnionRect.Bottom);
   end;
 { if FVerticalFlag then CvRef.Stroke.Color:=TAlphaColorRec.Red
  else CvRef.Stroke.Color:=TAlphaColorRec.Green;
   CvRef.DrawRect(UnionRect,0,0,[],1);
   }
end;

function TarAxis.RecalcLabels(apMin, apMax, aInterval,aOrtoValue:single):boolean;
var LMin,LMax,LV:single;
    i,LDiv:integer;
    Lpt:TcvPoint;
begin
  Result:=false;
  Labels.Clear;
  ///
  if (aInterval>0) and (Abs(apMax-apMin)/aInterval<=100) then
    begin
      LMin:=Floor(apMin/aInterval)*aInterval;
      LMax:=Ceil(apMax/aInterval)*aInterval;
      LDiv:=Round(Abs(LMax-LMin)/aInterval);
      FMin:=LMin;
      Fmax:=LMin+LDiv*aInterval;
      FInterval:=aInterval;
      FEnabled:=true;
    end
  else FEnabled:=false;
  Result:=FEnabled;
  if Result then
    begin
      LV:=FMin; i:=0;
      while LV<=FMax do
        begin
         if FVerticalFlag then
             Lpt:=TcvPoint.Create(i,aOrtoValue,LV,2)
         else
             Lpt:=TcvPoint.Create(i,LV,aOrtoValue,1);
         Labels.Add(Lpt);
         Inc(i);
         LV:=LV+FInterval;
        end;
    end;
end;

procedure TarAxis.SetCanvasRects(const AcvAllRect:TRectF; aCvMin, aCvMax, aCvOrto: single);
begin
 FCanvasRect:=AcvAllRect;
 if FVerticalFlag then
    FAxisCanvasRect:=RectF(aCvOrto-FlabelSize,aCvMin,aCvOrto,aCvMax)
 else
    FAxisCanvasRect:=RectF(aCvMin,aCvOrto,aCvMax,aCvOrto+FlabelSize);
end;

{ TarChartArea }

function TarChartArea.AddCurve(aNum:integer; aColor: TAlphaColor; aThickness: single;
  aDash: TStrokeDash; aMarkType: TmarkType; aMarkSize: single): integer;
 var Lcv:TarCurve;
     i:integer;
begin
  if ANum=0 then
     i:=Curves.Count
  else i:=aNum;
  ///  проверить на наличие номера в списке
  ///
  Lcv:=TarCurve.Create(i,aColor,aThickness,aDash,aMarkType,aMarkSize);
  Lcv.CvRef:=Self.CvRef;
  Result:=Curves.Add(LCv);
end;

procedure TarChartArea.ApplyAutoMargins(addAxisMargin,addFrameMargin:integer);
var LRect,LActRect:TRectF;
begin
 LRect:=AxisX.UnionRect;
 LRect.Union(AxisY.UnionRect);
 LActRect:=GetActiveArea;
 LRect.Union(LActRect);
 FMarginRect.Left:=LActRect.Left-Lrect.Left;
 FMarginRect.Top:=LActRect.Top-Lrect.Top;
 FMarginRect.Right:=LRect.Right-LActRect.Right;
 FMarginRect.Bottom:=LRect.Bottom-LActRect.Bottom;
 if FMarginRect.Left<0 then FMarginRect.Left:=0;
 if FMarginRect.Top<0 then FMarginRect.Top:=0;
 if FMarginRect.Right<0 then FMarginRect.Right:=0;
 if FMarginRect.Bottom<0 then FMarginRect.Bottom:=0;
 FMarginRect:=RectF(FMarginRect.Left+addAxisMargin,FMarginRect.Top+addFrameMargin,
                    FMarginRect.Right+addFrameMargin,FMarginRect.Bottom+addAxisMargin);
 F_addAxisMargin:=addAxisMargin;
 F_addFrameMargin:=addFrameMargin;
{ CvRef.Stroke.Color:=TAlphaColorRec.Red;
 CvRef.DrawRect(FMarginRect,0,0,[],1);
 }
end;

procedure TarChartArea.BringNumToFront(aNum: integer);
var L_index:integer;
begin
  if Curves.Count<2 then exit;
  L_index:=GetIndexFromNumber(aNum);
  if (L_index>=0) then
   begin
     Curves.Exchange(L_index,Curves.Count-1);
   end;
end;

constructor TarChartArea.Create(aFrameColor,aGridColor:TAlphaColor;
                       aGridDash:TStrokeDash=TStrokeDash.Solid; aLabelThickness:single=1);
begin
  inherited Create;
 // FMarginRect:=RectF(0,0,0,0);
  FMarginRect:=RectF(40,10,10,20);
  F_addAxisMargin:=25;
  F_addFrameMargin:=5;
  FAxisDivider:=PointF(10,10);
  AxisX:=TarAxis.Create(false,TAlphaColorRec.Black,TAlphaColorRec.Black,TAlphaColorRec.Black,4);
  AxisY:=TarAxis.Create(true,TAlphaColorRec.Black,TAlphaColorRec.Black,TAlphaColorRec.Black,4);
  FFrameBrush:=TStrokeBrush.Create(TBrushKind.Solid,aFrameColor);
  FFrameBrush.Thickness:=1.5;
  FGridType:=gtBoth;
  FGridBrush:=TStrokeBrush.Create(TBrushKind.Solid,aGridColor);
  FGridBrush.Thickness:=0.5;
  FGridBrush.Dash:=aGridDash;
  if FGridBrush.Dash=TStrokeDash.Dash then
     FGridBrush.SetCustomDash([3/FGridBrush.Thickness,5/FGridBrush.Thickness],0);
  Curves:=TobjectList<TarCurve>.Create(true);
  //
  FBackFill:=TBrush.Create(TBrushKind.Solid,TAlphaColorRec.Lightgray);
  FFrameFill:=TBrush.Create(TBrushKind.Solid,TAlphaColorRec.White);
end;

destructor TarChartArea.Destroy;
begin
  AxisX.Free;
  AxisY.Free;
  FGridBrush.Free;
  FFrameBrush.Free;
  ///
  Curves.Free;
  ///
  FBackFill.Free;
  FFrameFill.Free;
  inherited;
end;


procedure TarChartArea.RedrawAll;
begin
  SetCanvas(CvRef);
  ///
  with CvRef do
   begin
     FillRect(FCanvasArea,0,0,[],1,FBackFill,TCornerType.Bevel);
     FillRect(GetActiveArea,0,0,[],1,FFrameFill,TCornerType.Bevel);
   end;
  ///
  DrawGrid;
  DrawAxes;
  DrawCurves; // !
  DrawFrame;
  DrawBoundsRect;
end;

procedure TarChartArea.ResetAreaParams;
begin
 Self.SetAreaParams(FDataArea,FCanvasArea);
end;

procedure TarChartArea.ResetAutoMargins;
begin
 Self.ApplyAutoMargins(F_addAxisMargin,F_addFrameMargin);
end;

procedure TarChartArea.ResetCanvasArea(const aAreaCvRect: TRectF);
begin
  Self.SetAreaParams(FDataArea,aAreaCvRect);
end;

function TarChartArea.DrawAxes: boolean;
var LFlag:boolean;
begin
 Result:=false; LFlag:=false;
 if (FXYCoeffs.Y<>0) and (AxisY.Enabled=true) and (AxisY.Labels.Count>0) then
   begin
     Result:=AxisY.DrawLabelsAndLine;
     AxisY.DrawTitles;
   end;
  if (FXYCoeffs.X<>0) and (AxisX.Enabled=true) and (AxisX.Labels.Count>0) then
   begin
     LFlag:=AxisX.DrawLabelsAndLine;
     AxisX.DrawTitles;
   end;
 Result:=(result) or (LFlag);
end;

procedure TarChartArea.DrawBoundsRect(aCL:TAlphaColor=TAlphaColorRec.Darkgray; aThickness:single=0.8);
begin
 with cvRef do
  begin
     Stroke.Thickness:=0.8;
     Stroke.Color:=aCL;
     DrawRect(FCanvasArea,0,0,[],1,TCornerType.InnerLine);
  end;
end;

function TarChartArea.DrawCurve(const aCv: TarCurve): boolean;
begin
  Result:=false;
  if aCV.Enabled=true then
    begin
      aCV.ScalePoints(FDataArea,GetActiveArea);
      aCv.DrawPointLines;
      aCv.DrawPtMarks;
      aCv.DrawTitles;
      Result:=(aCv.Points.Count>0);
    end;
end;

function TarChartArea.DrawCurves: boolean;
var LCv:TarCurve;
    i:integer;
begin
  Result:=false;
 { for Lcv in Curves do
      if DrawCurve(Lcv) then
         Result:=true;
         }
   i:=0;
   while i<Curves.Count do
    begin
      LCv:=Curves.Items[i];
      if DrawCurve(Lcv) then
         Result:=true;
      Inc(i);
    end;

{  for I:=Curves.Count-1 downto 0 do
   begin
      LCv:=Curves.Items[i];
      if DrawCurve(Lcv) then
         Result:=true;
    end;
 }
end;

procedure TarChartArea.DrawFrame;
var LRect:TRectF;
begin
  LRect:=GetActiveArea;
  with CvRef do
   begin
     DrawLine(PointF(Lrect.Left,Lrect.Top),PointF(Lrect.Right,Lrect.Top),1,FFrameBrush);
     DrawLine(PointF(Lrect.Right,Lrect.Top),PointF(Lrect.Right,Lrect.Bottom),1,FFrameBrush);
   end;
end;

function TarChartArea.DrawGrid: boolean;
var LState:TCanvasSaveState;
    Lpt:TcvPoint;
    LRect:TRectF;
begin
 Result:=false;
 LRect:=GetActiveArea;
 LState:=CvRef.SaveState;
 with CvRef do
  try
    IntersectClipRect(LRect);
    if FGridType in [gtVertical,gtBoth] then
      if (FXYCoeffs.Y<>0) and (AxisY.Enabled=true) and (AxisY.Labels.Count>0) then
       begin
          for Lpt in AxisY.Labels do
           if (Lpt<>AxisY.Labels.First) and (Lpt<>AxisY.Labels.Last) then
              DrawLine(Lpt.Point,PointF(Lrect.Right,Lpt.Point.Y),1,FGridBrush);
          Result:=true;
       end;
    if FGridType in [gtHorizontal,gtBoth] then
     if (FXYCoeffs.X<>0) and (AxisX.Enabled=true) and (AxisX.Labels.Count>0) then
       begin
           for Lpt in AxisX.Labels do
            if (Lpt<>AxisX.Labels.First) and (Lpt<>AxisX.Labels.Last) then
               DrawLine(PointF(Lpt.Point.X,Lrect.Top),Lpt.Point,1,FGridBrush);
          Result:=true;
       end;
   finally
     RestoreState(LState);
   end;
end;

function TarChartArea.GetActiveArea: TRectF;
begin
 Result:=Rectf(FCanvasArea.Left+FMarginRect.Left,
                      FCanvasArea.Top+FMarginRect.Top,
                      FCanvasArea.Right-FMarginRect.Right,
                      FCanvasArea.Bottom-FMarginRect.Bottom);
end;


function TarChartArea.GetCurveFromNumber(aNum: integer): TarCurve;
var i:integer;
begin
   Result:=nil;
   i:=GetIndexFromNumber(aNum);
   if (i>=0) and (i<Curves.Count) then
      Result:=Curves.Items[i];
end;

function TarChartArea.GetIndexFromNumber(aNum: integer):integer;
 var i:integer;
     Lcv:TarCurve;
begin
   Result:=-1;
   i:=0;
   while i<Curves.Count do
    begin
      if Curves.Items[i].Number=aNum then
         begin
           Result:=i;
           break;
         end;
      Inc(i);
    end;
end;

procedure TarChartArea.PaintToBitmap(const ABM: TBitmap; aNewBMArea: TRectF;
  AutoMarginEnabled: boolean);
begin
  if Assigned(ABM) then
    begin
      ABM.SetSize(Trunc(aNewBMArea.Left+aNewBMArea.Width),Trunc(aNewBMArea.Top+aNewBMArea.Height));
      SetCanvas(ABM.Canvas);
      ABM.Canvas.BeginScene;
      try
       ResetCanvasArea(aNewBMArea);
       RedrawAll;
       if AutoMarginEnabled then
         begin
           ResetAutoMargins;
           ResetAreaParams;
           RedrawAll;
         end;
     finally
       ABM.Canvas.EndScene;
     end;
    end;
end;

procedure  TarChartArea.SetAreaParams(const aDataArea,aAreaCvRect:TRectF);
var Lpt:TcvPoint;
    LptX,LPtY:single;
    LCoeff:TPointF;
    L_Rect:TrectF;
begin
  FCanvasArea:=aAreaCvRect;
  FDataArea:=aDataArea;
  FXYCoeffs:=PointF(0,0);
  if (FDataArea.Width>0) and (FCanvasArea.Width-FMarginRect.Left-FMarginRect.Right>1) then
     FXYCoeffs.X:=(FCanvasArea.Width-FMarginRect.Left-FMarginRect.Right)/FDataArea.Width;
  if (FDataArea.Height>0) and (FCanvasArea.Height-FMarginRect.Top-FMarginRect.Bottom>1) then
     FXYCoeffs.Y:=(FCanvasArea.Height-FMarginRect.Top-FMarginRect.Bottom)/FDataArea.Height;
  ///
  ///  Axis recalc
  AxisX.RecalcLabels(FdataArea.left,FdataArea.Right,Abs(FDataArea.Width)/FAxisDivider.X,aDataArea.Bottom);
  AxisY.RecalcLabels(FdataArea.Top,FdataArea.Bottom,Abs(FDataArea.Height)/FAxisDivider.Y,aDataArea.Left);
  ///
   LCoeff:=PointF(AxisX.Interval*FXYCoeffs.X,AxisY.Interval*FXYCoeffs.Y);
   LptX:=FCanvasArea.Left+FMarginRect.Left;
   LptY:=FCanvasArea.Bottom-FMarginRect.Bottom;
   if (AxisX.Enabled) and (FXYCoeffs.X<>0) then
    for Lpt in AxisX.Labels do
        begin
          Lpt.Point:=PointF(LptX,LptY);
          LptX:=Lptx+LCoeff.X;
        end;
    LptX:=FCanvasArea.Left+FMarginRect.Left;
    LptY:=FCanvasArea.Bottom-FMarginRect.Bottom;
   if (AxisY.Enabled) and (FXYCoeffs.Y<>0) then
    for Lpt in AxisY.Labels do
        begin
          Lpt.Point:=PointF(LptX,LptY);
          LptY:=LptY-LCoeff.Y;
        end;
   ///
   ///
   L_Rect:=GetActiveArea;
   AxisX.SetCanvasRects(FCanvasArea,L_Rect.Left,L_Rect.Right,L_Rect.Bottom);
   AxisY.SetCanvasRects(FCanvasArea,L_Rect.Top,L_Rect.Bottom,L_Rect.Left);
end;

procedure TarChartArea.SetAxisDividerValues(adivX, adivY: single);
begin
  if aDivX>1 then
     FAxisDivider.X:=adivX;
    if aDivY>1 then
     FAxisDivider.Y:=adivY;
end;

procedure TarChartArea.SetAxisTextLabels(const AXtext, aYtext: string);
begin
  AxisX.TextLabel.Text:=AXtext;
  AxisY.TextLabel.Text:=AYtext;
end;

procedure TarChartArea.SetCanvas(const ACv: Tcanvas);
var Lcv:TarCurve;
begin
  Self.CvRef:=aCv;
  AxisX.CvRef:=aCV;
  AxisY.CvRef:=aCV;
  for Lcv in Curves do
     Lcv.CvRef:=aCV;
end;

{ TarAxisLabel }
/// from StackOverflow https://stackoverflow.com/questions/18229549/firemonkey-rotate-text
procedure DrawRotatedText(aCanvas: TCanvas; const P: TPointF; RadAngle: Single;
  const S: String; HTextAlign, VTextAlign: TTextAlign);
var
  W: Single;
  H: Single;
  R: TRectF;
  SaveMatrix: TMatrix;
  Matrix: TMatrix;
begin
  W := aCanvas.TextWidth(S);
  H := aCanvas.TextHeight(S);
  case HTextAlign of
    TTextAlign.taCenter:   R.Left := -W / 2;
    TTextAlign.taLeading:  R.Left := 0;
    TTextAlign.taTrailing: R.Left := -W;
  end;
  R.Width := W;
  case VTextAlign of
    TTextAlign.taCenter:   R.Top := -H / 2;
    TTextAlign.taLeading:  R.Top := 0;
    TTextAlign.taTrailing: R.Top := -H;
  end;
  R.Height := H;
  SaveMatrix := aCanvas.Matrix;
  try
   Matrix :=TMatrix.CreateRotation(RadAngle);
   Matrix.m31 := P.X;
   Matrix.m32 := P.Y;
   aCanvas.MultiplyMatrix(Matrix);
   aCanvas.FillText(R, S, False, 1, [], HTextAlign, VTextAlign);
   finally
    aCanvas.SetMatrix(SaveMatrix);
  end;
end;
////////////////////////////////////////////////////////

constructor TarAxisLabel.Create(aVerticalFlag: boolean; aColor:TAlphaColor;
  const aBackColor: TAlphaColor=TAlphaColorrec.Alpha);
begin
  inherited Create;
  FCanvasRect:=rect(0,0,0,0);
  FText:='DEFAULT';
  FVerticalFlag:=aVerticalFlag;
  FFont:=TFont.Create;
  FFontColor:=aColor;
  FbackBrush:=TBrush.Create(TBrushKind.Solid,aBackColor);
////  FbackBrush.Color:=aBackColor;
  FVisible:=true;
end;

destructor TarAxisLabel.Destroy;
begin
  FFont.Free;
  FbackBrush.Free;
  inherited;
end;

function TarAxisLabel.Draw(const aCV:Tcanvas; const aCvRect:TRectF; aCnX,aCnY:single): boolean;
var LRotate,LW,LH:single;
    L_Rect:TRectF;
begin
  Result:=false;
  if (FVisible=false) or (Trim(FText)='') then exit;
  if FVerticalFlag then LRotate:=DegToRad(-90)
  else LRotate:=0;
  aCV.Font.Assign(FFont);
  aCV.Fill.Assign(FbackBrush);
  LW:=aCV.TextWidth(FText);
  LH:=aCV.TextHeight(FText);
  if FVerticalFlag then
     FCenter:=PointF(aCvRect.left+0.5*(aCnx-aCvRect.left),aCnY)
  else
     FCenter:=PointF(aCnx,aCvRect.Bottom-0.5*(aCvRect.Bottom-aCnY));
  /// проверка на выход за пределы
  ///  ...
  ///
  if LRotate<>0 then
   begin
     DrawRotatedText(aCV,FCenter,LRotate,FText,TTextAlign.Center,TTextAlign.Center);
     L_Rect:=RectF(FCenter.X-0.5*LH,FCenter.Y-0.5*LW,FCenter.X+0.5*LH,FCenter.Y+0.5*LW);
   end
  else
     begin
       L_Rect:=RectF(FCenter.X-0.5*LW,FCenter.Y-0.5*LH,FCenter.X+0.5*LW,FCenter.Y+0.5*LH);
       aCV.FillText(L_Rect,FText,False,1,[],TTextAlign.Center,TTextAlign.Center);
     end;
  FRect:=L_Rect;
  Result:=true;
end;


end.

