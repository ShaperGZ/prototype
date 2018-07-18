class BH_Apt_FaceConstraint < Arch::BlockUpdateBehaviour
  def initialize(gp,host)
    super(gp,host)
  end

  def onClose(e)
    #p 'constrain face.onClose'
    constrain_all
  end

  def onElementModified(entities, e)
    #p 'constrain face.onElementModified'
  end

  def onChangeEntity(e, invalidated)
    return if not invalidated[2]
    p '-> BH_FaceConstrain.onChangeEntity'
    #p 'constrain face.onChangeEntity'
    constrain_all
  end


  def constrain_all()
    @enableUpdate=false
    wu = 3 * $m2inch
    wv = 3 * $m2inch
    ArchUtil.constraint_gp(@gp,wu,wv)
  end



end