//
// light_disable.fx
//
 
///////////////////////////////////////////////////////////////////////////////
// Technique
///////////////////////////////////////////////////////////////////////////////
technique light_disable
{
    pass P0
    {
        LightEnable[1] = false;
        LightEnable[2] = false;
        LightEnable[3] = false;
        LightEnable[4] = false;
    }
}