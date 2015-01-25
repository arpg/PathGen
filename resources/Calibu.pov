union
{
  mesh2
  {
    vertex_vectors
    {
      4,

      // top-right vertex
	<0.0, 0.29487307844, 0.40529397536>,
	// top-left
	<0.0, 0.29487307844, -0.40529397536>,

	// bottom-left
	<0.0, -0.29487307844, -0.40529397536>,
	
	// bottom-right
	<0.0, -0.29487307844, 0.40529397536>
    }

    normal_vectors
    {
      4,

      <-1.000000, 0.000000, 0.000000>,
      <-1.000000, 0.000000, 0.000000>,
      <-1.000000, 0.000000, 0.000000>,
      <-1.000000, 0.000000, 0.000000>
    }

    uv_vectors
    {
      4,

      <0.000000,1.000000>,
      <0.000000,0.000000>,
      <1.000000,0.000000>,
      <1.000000,1.000000>
    }
    
    face_indices
    {
      2,
      <0,1,3>,
      <3,1,2>
    }
    
    uv_indices
    {
      2,
      <0,1,3>,
      <3,1,2>
    }
    
    uv_mapping

    texture
    {
      pigment
      {
        image_map
        {
          png "calibu-target-medium.png" interpolate 2
        }
      }
    }
  }
  rotate < 90, 0, 0 >
  scale < 1.0000, 1.0000, 1.0000 >
}

light_source {<-5, 0, 0> color rgb < 2 2 2 >}
