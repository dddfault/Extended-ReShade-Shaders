///////////////////////////////////////////////////////////////////////////
// Color Mod
///////////////////////////////////////////////////////////////////////////
// Original code by Ryosuke839
// Ported to ReShade 2.0 by Marty McFly
// Ported to ReShade 4.0 by Insomnia
// Modified by dddfault
///////////////////////////////////////////////////////////////////////////

// INITIAL SETUP //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
#include "ReShade.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
uniform float cmodChroma <
  ui_label    = "Color Mod Chroma";
  ui_tooltip  = "Saturation adjustment for corresponding color";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = 0.7;

uniform float3 cmodGamma <
  ui_label    = "Color Mod Gamma";
  ui_tooltip  = "Gamma adjustment for corresponding color";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = float3(1.0, 1.0, 1.0);

uniform float3 cmodContrast <
  ui_label    = "Color Mod Contrast";
  ui_tooltip  = "Contrast adjustment for corresponding color";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = float3(1.0, 1.0, 1.0);

uniform float3 cmodBrightness <
  ui_label    = "Color Mod Brightness";
  ui_tooltip  = "Brightness adjustment for corresponding color";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = float3(0.0, 0.0, 0.0);

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_ColorMod(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);
  color.rgb = (color.rgb - dot(color.rgb, 0.333)) * cmodChroma + dot(color.rgb, 0.333);
	color.rgb = saturate(color.rgb);
	color.r = (pow(color.r, cmodGamma.x) - 0.5) * cmodContrast.x + 0.5 + cmodBrightness.x;
	color.g = (pow(color.g, cmodGamma.y) - 0.5) * cmodContrast.y + 0.5 + cmodBrightness.y;
	color.b = (pow(color.b, cmodGamma.z) - 0.5) * cmodContrast.z + 0.5 + cmodBrightness.z;
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique ColorMod
{
  pass cMod
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_ColorMod;
  }
}
