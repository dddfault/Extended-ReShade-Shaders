///////////////////////////////////////////////////////////////////////////
// Fisheye
///////////////////////////////////////////////////////////////////////////
// Original code by icelaglace, a.o => (ported from some blog, author unknown)
// Ported to ReShade 2.0 by Marty McFly
// Ported to ReShade 4.0 by Insomnia
// Modified by dddfault
///////////////////////////////////////////////////////////////////////////

// INITIAL SETUP //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
#include "ReShade.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
uniform int fisheyeOrientation <
  ui_label    = "Fish Eye Mode";
  ui_type     = "combo";
  ui_items    = "Horizontal\0Vertical\0Combined\0";
  ui_min      = 0;
  ui_max      = 2;
  > = 2;

uniform float fFisheyeZoom <
  ui_label    = "Fish Eye Zoom";
  ui_tooltip  = "Lens zoom to hide bugged edges due to texcoord modification";
  ui_type     = "drag";
  ui_min      = -0.5;
  ui_max      = 1.0;
  ui_step     = 0.001;
  > = 0.55;

uniform float fFisheyeDistortion <
  ui_label    = "Fisheye Distortion";
  ui_tooltip  = "Distortion of image";
  ui_type     = "drag";
  ui_min      = -0.800;
  ui_max      = 0.800;
  ui_step     = 0.001;
  > = 0.01;

uniform float fFisheyeDistortionCubic <
  ui_label    = "Fisheye Distortion Cubic";
  ui_tooltip  = "Distortion of image, cube based";
  ui_type     = "drag";
  ui_min      = -0.800;
  ui_max      = 0.800;
  ui_step     = 0.001;
  > = 0.7;

uniform float fFisheyeColorshift <
  ui_label    = "Colorshift";
  ui_tooltip  = "Amount of color shifting";
  ui_type     = "drag";
  ui_min      = -0.10;
  ui_max      = 0.10;
  ui_step     = 0.001;
  > = 0.002;

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_Fisheye(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color    = tex2D(ReShade::BackBuffer, texcoord.xy);

  float f, r2;
  float2 coord, center, distort, rCoords, gCoords, bCoords;
  float3 eta;

	coord.xy = texcoord.xy;
	center.x = coord.x - 0.5;
	center.y = coord.y - 0.5;

  eta      = float3(1.0 + fFisheyeColorshift * 0.9, 1.0 + fFisheyeColorshift * 0.6, 1.0 + fFisheyeColorshift * 0.3);

  switch(fisheyeOrientation)
  {
    case 0: {
     r2 = (texcoord.y - 0.5) * (texcoord.y - 0.5);
    break;
    }
    case 1: {
     r2 = (texcoord.x - 0.5) * (texcoord.x - 0.5);
     break;
    }
    case 2: {
     r2 = (texcoord.x - 0.5) * (texcoord.x - 0.5) + (texcoord.y - 0.5) * (texcoord.y - 0.5);
    break;
    }
  }

  if(fFisheyeDistortionCubic == 0)
  {
		f = 1 + r2 * fFisheyeDistortion;
	}
  else
  {
    f = 1 + r2 * (fFisheyeDistortion + fFisheyeDistortionCubic * sqrt(r2));
	};

	distort.x = f * (1.0 / fFisheyeZoom) * (coord.x - 0.5) + 0.5;
	distort.y = f * (1.0 / fFisheyeZoom) * (coord.y - 0.5) + 0.5;

	rCoords   = (f * eta.r) * (1.0 / fFisheyeZoom) * (center.xy * 0.5) + 0.5;
	gCoords   = (f * eta.g) * (1.0 / fFisheyeZoom) * (center.xy * 0.5) + 0.5;
	bCoords   = (f * eta.b) * (1.0 / fFisheyeZoom) * (center.xy * 0.5) + 0.5;

	color.r   = tex2D(ReShade::BackBuffer, rCoords).r;
	color.g   = tex2D(ReShade::BackBuffer, gCoords).g;
	color.b   = tex2D(ReShade::BackBuffer, bCoords).b;

  color.a = 1.0;
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique Fisheye
{
  pass fishEye
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_Fisheye;
  }
}
