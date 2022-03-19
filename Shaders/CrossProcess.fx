///////////////////////////////////////////////////////////////////////////
// Cross Process
///////////////////////////////////////////////////////////////////////////
// Original code by AgaintsAllAuthority / opezdl
// Ported to ReShade 2.0 by Marty McFly
// Ported to ReShade 4.0 by Insomnia
// Modified by dddfault
///////////////////////////////////////////////////////////////////////////

// INITIAL SETUP //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
#include "ReShade.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
uniform float CrossContrast <
  ui_label    = "Contrast";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 2.0;
  ui_step     = 0.01;
  > = 1.0;

uniform float CrossSaturation <
  ui_label    = "Saturation";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 2.0;
  ui_step     = 0.01;
  > = 1.0;

uniform float CrossBrightness <
  ui_label    = "Brightness";
  ui_type     = "drag";
  ui_min      = -1.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = 0.0;

uniform float CrossAmount <
  ui_label    = "Amount";
  ui_type     = "drag";
  ui_min      = 0.05;
  ui_max      = 2.0;
  ui_step     = 0.01;
  > = 0.7;
// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_XProcess(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);

	float2 CrossMatrix [3] = {
		float2 (1.03, 0.04),
		float2 (1.09, 0.01),
		float2 (0.78, 0.13),
 		};

	float3 image1 = color.rgb;
	float3 image2 = color.rgb;
	float gray = dot(float3(0.5,0.5,0.5), image1);
	image1 = lerp (gray, image1, CrossSaturation);
	image1 = lerp (0.35, image1, CrossContrast);
	image1 += CrossBrightness;
	image2.r = image1.r * CrossMatrix[0].x + CrossMatrix[0].y;
	image2.g = image1.g * CrossMatrix[1].x + CrossMatrix[1].y;
	image2.b = image1.b * CrossMatrix[2].x + CrossMatrix[2].y;
	color.rgb = lerp(image1, image2, CrossAmount);
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique CrossProcess
{
  pass xProcess
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_XProcess;
  }
}
