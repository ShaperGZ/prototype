module ArchUtil
  def ArchUtil.constraint_gp(gp,u=1,v=1,w=nil)
    wu = u * $m2inch
    wv = v * $m2inch

    xfaces=[]
    gp.entities.each{|e|
      if e.class == Sketchup::Face and e.normal.x.abs == 1
        xfaces<<e
      end
    }
    p xfaces
    for i in 0..xfaces.size
      ArchUtil.constrain_face_x(xfaces[i],wu,gp.transformation.xscale)
    end

  end

  def ArchUtil.constrain_face_x(f,w,scale_factor=1)
    if f == nil
      p 'f==nil'
      return
    end

    return if f.class != Sketchup::Face and f.normal.x.abs != 1

    w/=scale_factor
    pos=f.vertices[0].position
    offset = ArchUtil.get_val_offset(pos.x,w)
    f.pushpull(offset)

  end

  def ArchUtil.offset_verts(entities,x_dict=nil,y_dict=nil)
    if x_dict !=nil
      for i in 0..x_dict.size-1
        k=x_dict.keys[i]
        v=x_dict[k]
        p "k=#{k}, v=#{v}"
        t=Geom::Transformation.translation(Geom::Vector3d.new(k,0,0))
        entities.transform_entities(t, v)
      end
    end

    if y_dict !=nil
      for i in 0..y_dict.size-1
        k=y_dict.keys[i]
        v=y_dict[k]
        p "k=#{k}, v=#{v}"
        t=Geom::Transformation.translation(Geom::Vector3d.new(0,k,0))
        entities.transform_entities(t, v)
      end
    end

  end

  def ArchUtil.sort_verts_by_offset(gp,wu,wv)
    wu /= gp.transformation.xscale
    wv /= gp.transformation.yscale

    verts=ArchUtil.getVerts(gp.entities)
    x_dict=Hash.new
    y_dict=Hash.new

    verts.each{|v|
      offset_u,offset_v=ArchUtil.get_pt_offset(v.position,wu,wv)
      if x_dict.key?(offset_u)
        x_dict[offset_u]<<v if offset_u!=0
      else
        x_dict[offset_u]=[v] if offset_u!=0
      end

      if y_dict.key?(offset_v)
        y_dict[offset_v]<<v if offset_u!=0
      else
        y_dict[offset_v]=[v] if offset_u!=0
      end
    }
    return x_dict,y_dict
  end

  def ArchUtil.get_pt_offset(pt,wu,wv)
    offset_u=ArchUtil.get_val_offset(pt.x,wu)
    offset_v=ArchUtil.get_val_offset(pt.y,wv)
    return offset_u,offset_v
  end

  def ArchUtil.get_val_offset(length,unit_width)
    remain=length % unit_width
    if remain<(unit_width/2)
      offset=-remain
    else
      offset=unit_width-remain
    end
    return offset
  end
end