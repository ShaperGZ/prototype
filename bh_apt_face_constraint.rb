class BH_Apt_FaceConstraint < Arch::BlockUpdateBehaviour
  #TODO:
  # export attributes:
  # ui_apt_cap_max
  # ui_apt_cap_min
  # ui_apt_void_max
  # ui_apt_void_min
  # 
  def initialize(gp,host)
    super(gp,host)

    @widths=[3,1.5,nil]
    @caps=[nil,[15,-15],nil]
    @voids=[nil,[10,-10],nil]
  end

  def onClose(e)
    #p 'constrain face.onClose'
    constraint_all
  end

  def onElementModified(entities, e)

    return if e.class != Sketchup::Face or !  e.valid?
    dir=nil
    for i in 0..2
      if e.normal[i]==1
        dir=i
        break
      end
    end
    return if dir==nil
    t=@gp.transformation
    #scales=[t.xscale,t.yscale,t.zscale]
    scales=[1,1,1]
    ArchUtil.constrain_face_dir(e,dir,@widths[dir],scales[dir],
                                @caps[dir],@voids[dir])
  end

  def onChangeEntity(e, invalidated)
    return if not invalidated[2]
    p '-> BH_FaceConstrain.onChangeEntity'
    #p 'constrain face.onChangeEntity'
    constraint_all
  end


  def constraint_all()
    @enableUpdate=false
    ftfh=@gp.get_attribute("BuildingBlock","bd_ftfh")
    @widths[2]=ftfh
    ArchUtil.constraint_gp(@gp,@widths,@caps,@voids)
    @enableUpdate=true
  end



end