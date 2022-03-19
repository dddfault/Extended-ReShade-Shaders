///////////////////////////////////////////////////////////////////////////
// Reinhard Tonemapping
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
uniform float ReinhardWhitepoint <
  ui_label    = "Reinhard White Point";
  ui_tooltip  = "Point above which everything is pure white";
  ui_type     = "drag";
  ui_min      = 1.0;
  ui_max      = 10.0;
  ui_step     = 0.01;
  > = 4.0;

uniform float ReinhardScale <
  ui_label    = "Reinhard Scale";
  ui_tooltip  = "Amount of applied tonemapping";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 2.0;
  ui_step     = 0.01;
  > = 0.5;

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_ReinhardTonemap(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);
  color.rgb = (1 + ReinhardScale * color.rgb / (ReinhardWhitepoint * ReinhardWhitepoint)) * color.rgb / (color.rgb + ReinhardScale);
  color.a   = 1.0;
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique ReinhardTonemapping
{
  pass reinhardTonemap
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_ReinhardTonemap;
  }
}
