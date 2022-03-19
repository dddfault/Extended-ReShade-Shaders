///////////////////////////////////////////////////////////////////////////
// Reinhard Linear Tonemapping
///////////////////////////////////////////////////////////////////////////
// Original code by Ubisoft
// Ported to ReShade 2.0 by Marty McFly
// Ported to ReShade 4.0 by Insomnia
// Modified by dddfault
///////////////////////////////////////////////////////////////////////////

// INITIAL SETUP //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
#include "ReShade.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
uniform float ReinhardLinearWhitepoint <
  ui_label    = "Reinhard Linear White Point";
  ui_tooltip  = "Linear white point value";
  ui_type     = "drag";
  ui_min      = 1.0;
  ui_max      = 10.0;
  ui_step     = 0.01;
  > = 4.4;

uniform float ReinhardLinearPoint <
  ui_label    = "Reinhard Linear Point";
  ui_tooltip  = "Linear point";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 2.0;
  ui_step     = 0.01;
  > = 0.05;

  uniform float ReinhardLinearSlope <
    ui_label    = "Reinhard Linear Slope";
    ui_tooltip  = "Slope of the linear section";
    ui_type     = "drag";
    ui_min      = 1.0;
    ui_max      = 5.0;
    ui_step     = 0.01;
    > = 2.25;

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_ReinhardLinTonemap(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);

  const float W = ReinhardLinearWhitepoint; // Linear White Point Value
  const float L = ReinhardLinearPoint;      // Linear point
  const float C = ReinhardLinearSlope;      // Slope of the linear section
  const float K = (1 - L * C) / C;          // Scale (fixed so that the derivatives of the Reinhard and linear functions are the same at x = L)
  float3 reinhard = L * C + (1 - L * C) * (1 + K * (color.rgb - L) / ((W - L) * (W - L))) * (color.rgb - L) / (color.rgb - L + K);

  color.rgb = (color.rgb > L) ? reinhard : C * color.rgb;
  color.a   = 1.0;
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique ReinhardLinearTonemapping
{
  pass reinhardLinTonemap
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_ReinhardLinTonemap;
  }
}
