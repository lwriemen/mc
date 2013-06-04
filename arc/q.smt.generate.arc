.//====================================================================
.// $RCSfile: q.smt.generate.arc,v $
.//
.// (c) Copyright 1998-2013 Mentor Graphics Corporation  All rights reserved.
.//====================================================================
.// ----------------------------------------------------------
.// gen for statements
.// ----------------------------------------------------------
.function smt_fors
.select many act_fors from instances of ACT_FOR
.for each act_for in act_fors
  .invoke smt_for( act_for )
.end for
.end function
.// --------------------------------------------------------
.// gen for statement
.// --------------------------------------------------------
.function smt_for
  .param inst_ref act_for
  .select any te_for from instances of TE_FOR
  .select one te_smt related by act_for->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one te_class related by act_for->O_OBJ[R670]->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .select one v_var related by act_for->V_VAR[R614]
    .select one te_var related by v_var->TE_VAR[R2039]
    .select one set_v_var related by act_for->V_VAR[R652]
    .select one set_te_var related by set_v_var->TE_VAR[R2039]
    .assign te_for.isImplicit = act_for.is_implicit
    .assign te_for.class_name = te_class.GeneratedName
    .assign te_for.loop_variable = te_var.buffer
    .assign te_for.set_variable = set_te_var.buffer
    .invoke s = t_oal_smt_for( te_smt, te_for, te_blk.indentation )
    .assign te_smt.declaration = s.declaration
    .assign te_smt.buffer = s.body
    .assign te_smt.buffer2 = s.ending
    .assign te_smt.OAL = "FOR EACH ${v_var.Name} IN ${set_v_var.Name}"
  .end if
.end function
.//
.// ----------------------------------------------------------
.// gen if statements
.// ----------------------------------------------------------
.function smt_ifs
.select many act_ifs from instances of ACT_IF
.for each act_if in act_ifs
  .invoke smt_if( act_if )
.end for
.end function
.// --------------------------------------------------------
.// gen if statement
.// --------------------------------------------------------
.function smt_if
  .param inst_ref act_if
  .select one te_smt related by act_if->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one condition_te_val related by act_if->V_VAL[R625]->TE_VAL[R2040]
  .invoke s = t_oal_smt_if( condition_te_val.buffer, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.buffer2 = s.ending
  .assign te_smt.OAL = "IF ( ${condition_te_val.OAL} )"
.end function
.// ----------------------------------------------------------
.// gen while statements
.// ----------------------------------------------------------
.function smt_whiles
.select many act_whls from instances of ACT_WHL
.for each act_whl in act_whls
  .invoke smt_while( act_whl )
.end for
.end function
.// --------------------------------------------------------
.// gen while statement
.// --------------------------------------------------------
.function smt_while
  .param inst_ref act_whl
  .select one te_smt related by act_whl->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one condition related by act_whl->V_VAL[R626]->TE_VAL[R2040]
  .invoke s = t_oal_smt_while( condition.buffer, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.buffer2 = s.ending
  .assign te_smt.OAL = "WHILE ( ${condition.OAL} )"
.end function
.// ----------------------------------------------------------
.// gen else statements
.// ----------------------------------------------------------
.function smt_elses
.select many act_es from instances of ACT_E
.for each act_e in act_es
  .invoke smt_else( act_e )
.end for
.end function
.// --------------------------------------------------------
.// gen else statement
.// --------------------------------------------------------
.function smt_else
  .param inst_ref act_e
  .select one te_smt related by act_e->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .invoke s = t_oal_smt_else( te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.buffer2 = s.ending
  .// Skip tracing ELSE because it falls between } and else.
  .//.assign te_smt.OAL = "ELSE"
  .assign te_smt.OAL = ""
.end function
.//
.// ----------------------------------------------------------
.// gen elif statements
.// ----------------------------------------------------------
.function smt_elifs
.select many act_els from instances of ACT_EL
.for each act_el in act_els
  .invoke smt_elif(act_el)
.end for
.end function
.// --------------------------------------------------------
.// gen elif statement
.// --------------------------------------------------------
.function smt_elif
  .param inst_ref act_el
  .select one te_smt related by act_el->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one condition related by act_el->V_VAL[R659]->TE_VAL[R2040]
  .invoke s = t_oal_smt_elif( condition.buffer, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.buffer2 = s.ending
  .// Skip tracing ELIF because it falls between } and else.
  .//.assign te_smt.OAL = "ELIF ( ${condition.OAL} )"
  .assign te_smt.OAL = ""
.end function
.//
.// --------------------------------------------------------
.// assignment to attribute statements
.// --------------------------------------------------------
.function smt_assigns
.select many act_ais from instances of ACT_AI
.for each act_ai in act_ais
  .invoke smt_assign( act_ai )
.end for
.end function
.//
.// --------------------------------------------------------
.// gen_asgn_attr_statement
.// --------------------------------------------------------
.function smt_assign
  .param inst_ref act_ai
  .select any te_assign from instances of TE_ASSIGN
  .select one te_smt related by act_ai->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one r_v_val related by act_ai->V_VAL[R609]
  .select one l_v_val related by act_ai->V_VAL[R689]
  .select one r_te_dt related by r_v_val->S_DT[R820]->TE_DT[R2021]
  .select one l_te_dt related by l_v_val->S_DT[R820]->TE_DT[R2021]
  .select one r_te_val related by r_v_val->TE_VAL[R2040]
  .select one l_te_val related by l_v_val->TE_VAL[R2040]
  .select one s_sdt related by r_v_val->S_DT[R820]->S_SDT[R17]
  .if ( empty l_te_dt )
    .assign l_te_dt = r_te_dt
  .end if
  .assign te_assign.Core_Typ = r_te_dt.Core_Typ
  .assign te_assign.rval_dimensions = r_te_val.dimensions
  .assign te_assign.dimensions = l_te_val.dimensions
  .assign te_assign.array_spec = l_te_val.array_spec
  .assign te_assign.left_declaration = ""
  .assign te_assign.lval = l_te_val.buffer
  .assign te_assign.rval = r_te_val.buffer
  .invoke r = V_VAL_drill_for_V_VAL_root( l_v_val )
  .assign root_v_val = r.result
  .assign te_assign.isImplicit = root_v_val.isImplicit
  .if ( te_assign.isImplicit )
    .select one root_te_val related by root_v_val->TE_VAL[R2040]
    .assign te_assign.left_declaration = ( r_te_dt.ExtName + " " ) + root_te_val.buffer
    .if ( 8 == r_te_dt.Core_Typ )
      .// CDS - This should change when generic instance references are converted to IRDTs.
      .select one te_class related by root_v_val->V_IRF[R801]->V_VAR[R808]->V_INT[R814]->O_OBJ[R818]->TE_CLASS[R2019]
      .if ( not_empty te_class )
        .assign te_assign.left_declaration = ( te_class.GeneratedName + " * " ) + root_te_val.buffer
      .end if
    .elif ( 9 == r_te_dt.Core_Typ )
      .// no need to do anything special here, because the type will be vanilla set base class
    .end if
  .end if
  .assign element_count = 0
  .select one r_te_dim related by r_te_val->TE_DIM[R2079]
  .if ( not_empty r_te_dim )
    .assign element_count = r_te_dim.elementCount
  .end if
  .assign is_parameter = false
  .select one v_pvl related by r_v_val->V_PVL[R801]
  .if ( not_empty v_pvl )
    .assign is_parameter = true
  .end if
  .invoke s = t_oal_smt_assign( te_smt, te_assign, te_blk.indentation, element_count, is_parameter )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "ASSIGN ${l_te_val.OAL} = ${r_te_val.OAL}"
.end function
.//
.// Find the root of the given value instance.  We may need to 
.// recurse down in the case of structures and arrays.
.function V_VAL_drill_for_V_VAL_root
  .param inst_ref v_val
  .assign attr_result = v_val
  .select one root_v_val related by v_val->V_AER[R801]->V_VAL[R838]
  .if ( not_empty root_v_val )
    .invoke r = V_VAL_drill_for_V_VAL_root( root_v_val )
    .assign attr_result = r.result
  .else
    .select one root_v_val related by v_val->V_MVL[R801]->V_VAL[R837]
    .if ( not_empty root_v_val )
      .invoke r = V_VAL_drill_for_V_VAL_root( root_v_val )
      .assign attr_result = r.result
    .end if
  .end if
.end function
.//
.//
.// --------------------------------------------------------
.// create instance statements
.// --------------------------------------------------------
.function smt_create_instances
  .select many act_crs from instances of ACT_CR
  .for each act_cr in act_crs
    .invoke smt_create_instance( act_cr )
  .end for
.end function
.//
.// --------------------------------------------------------
.// create instance statement
.// --------------------------------------------------------
.function smt_create_instance
  .param inst_ref act_cr
  .select one te_smt related by act_cr->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one o_obj related by act_cr->O_OBJ[R671]
  .select one te_class related by o_obj->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .select one v_var related by act_cr->V_VAR[R633]
    .select one te_var related by v_var->TE_VAR[R2039]
    .invoke s = t_oal_smt_create_instance( o_obj, act_cr.is_implicit, te_class.GeneratedName, te_var.buffer, te_blk.indentation )
    .assign te_smt.declaration = s.declaration
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "CREATE OBJECT INSTANCE ${v_var.Name} OF ${te_class.Key_Lett}"
  .end if
.end function
.//
.// --------------------------------------------------------
.// delete instance statements
.// --------------------------------------------------------
.function smt_delete_instances
  .select many act_dels from instances of ACT_DEL
  .assign del_count = 0
  .for each act_del in act_dels
    .invoke smt_delete_instance( act_del, del_count )
    .assign del_count = del_count + 1
  .end for
.end function
.//
.// --------------------------------------------------------
.// delete instance statement
.// --------------------------------------------------------
.function smt_delete_instance
  .param inst_ref act_del
  .param integer del_count
  .select one te_smt related by act_del->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one v_var related by act_del->V_VAR[R634]
  .select one te_var related by v_var->TE_VAR[R2039]
  .select one v_int related by v_var->V_INT[R814]
  .if ( empty v_int )
    .print "ERROR:  delete statement does not have a related variable (V_INT)."
    .exit 100
  .end if
  .select one o_obj related by v_int->O_OBJ[R818]
  .invoke s = t_oal_smt_delete_instance( o_obj, te_var.buffer, del_count, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "DELETE OBJECT INSTANCE ${v_var.Name}"
.end function
.// --------------------------------------------------------
.// create event instance to instance statements
.// --------------------------------------------------------
.function smt_create_events_to_instance
  .select many e_ceis from instances of E_CEI
  .for each e_cei in e_ceis
    .invoke smt_create_event_to_instance( e_cei )
  .end for
.end function
.//
.// --------------------------------------------------------
.// create event instance to class statements
.// --------------------------------------------------------
.function smt_create_events_to_class
  .select many e_ceas from instances of E_CEA
  .for each e_cea in e_ceas
    .invoke smt_create_event_to_class( e_cea )
  .end for
.end function
.//
.// --------------------------------------------------------
.// create event instance to creator statements
.// --------------------------------------------------------
.function smt_create_events_to_creator
  .select many e_cecs from instances of E_CEC
  .for each e_cec in e_cecs
    .invoke smt_create_event_to_creator( e_cec )
  .end for
.end function
.//
.// --------------------------------------------------------
.// create event instance statement
.// --------------------------------------------------------
.function smt_create_event_to_instance
  .param inst_ref e_cei
  .select one e_csme related by e_cei->E_CSME[R704]
  .select one recipient_v_var related by e_cei->V_VAR[R711]
  .select one recipient_te_var related by recipient_v_var->TE_VAR[R2039]
  .invoke smt_create_event( e_csme, recipient_te_var.buffer, recipient_v_var.Name )
.end function
.function smt_create_event_to_class
  .param inst_ref e_cea
  .select one e_csme related by e_cea->E_CSME[R704]
  .invoke smt_create_event( e_csme, "0", "CLASS" )
.end function
.function smt_create_event_to_creator
  .param inst_ref e_cec
  .select one e_csme related by e_cec->E_CSME[R704]
  .invoke smt_create_event( e_csme, "0", "CREATOR" )
.end function
.//
.// --------------------------------------------------------
.// create event instance statement
.// --------------------------------------------------------
.function smt_create_event
  .param inst_ref e_csme
  .param string recipient
  .param string recipient_OAL
  .select one e_ces related by e_csme->E_CES[R702]
  .select one e_ess related by e_ces->E_ESS[R701]
  .select one te_smt related by e_ess->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one sm_evt related by e_csme->SM_EVT[R706]
  .select one o_obj related by sm_evt->SM_SM[R502]->SM_ISM[R517]->O_OBJ[R518]
  .select one v_var related by e_ces->V_VAR[R710]
  .select one te_var related by v_var->TE_VAR[R2039]
  .select many v_pars related by e_ess->V_PAR[R700]
  .assign parameters = ""
  .assign parameter_OAL = ""
  .if ( not_empty v_pars )
    .assign delimeter = ""
    .for each v_par in v_pars
      .select one par_te_dt related by v_par->V_VAL[R800]->S_DT[R820]->TE_DT[R2021]
      .select one par_te_val related by v_par->V_VAL[R800]->TE_VAL[R2040]
      .invoke r = t_oal_smt_event_parameters( te_var.buffer, v_par.Name, par_te_val.buffer, par_te_dt.Core_Typ, te_blk.indentation )
      .assign parameters = parameters + r.result
      .assign parameter_OAL = ( parameter_OAL + delimeter ) + par_te_val.OAL
      .assign delimeter = ", "
    .end for
  .end if
  .if ( empty o_obj )
    .select one o_obj related by sm_evt->SM_SM[R502]->SM_ASM[R517]->O_OBJ[R519]
  .end if
  .select one sm_pevt related by sm_evt->SM_PEVT[R525]
  .if ( not_empty sm_pevt )
    .select any poly_sm_evt related by o_obj->SM_ISM[R518]->SM_SM[R517]->SM_EVT[R502] where ( selected.Drv_Lbl == "${event.Drv_Lbl}*" )
    .if ( not_empty poly_sm_evt )
      .assign sm_evt = poly_sm_evt
    .end if
  .end if
  .invoke s = t_oal_smt_create_event( sm_evt, e_ces.is_implicit, o_obj.Name, sm_evt.Mning, v_var.Name, te_var.buffer, recipient, parameters, te_blk.indentation )
  .assign te_smt.declaration = s.declaration
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "CREATE EVENT INSTANCE ${v_var.Name}( ${parameter_OAL} ) TO ${recipient_OAL}"
.end function
.//
.// --------------------------------------------------------
.//  relate statements
.// --------------------------------------------------------
.function smt_relates
  .select many act_rels from instances of ACT_REL
  .for each act_rel in act_rels
    .invoke smt_relate( act_rel )
  .end for
.end function
.//
.// --------------------------------------------------------
.//  relate statement
.// --------------------------------------------------------
.function smt_relate
  .param inst_ref act_rel
  .select one te_smt related by act_rel->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one one_v_var related by act_rel->V_VAR[R615]
  .select one one_te_var related by one_v_var->TE_VAR[R2039]
  .select one one_o_obj related by one_v_var->V_INT[R814]->O_OBJ[R818]
  .select one te_class related by one_o_obj->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .select one oth_v_var related by act_rel->V_VAR[R616]
    .select one oth_te_var related by oth_v_var->TE_VAR[R2039]
    .select one oth_o_obj related by oth_v_var->V_INT[R814]->O_OBJ[R818]
    .select one r_rel related by act_rel->R_REL[R653]
    .invoke is_refl = is_reflexive( r_rel )
    .invoke s = t_oal_smt_relate( one_o_obj, oth_o_obj, r_rel, is_refl.result, r_rel.Numb, act_rel.relationship_phrase, one_te_var.buffer, oth_te_var.buffer, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "RELATE ${one_v_var.Name} TO ${oth_v_var.Name} ACROSS R${r_rel.Numb}"
  .end if
.end function
.//
.// --------------------------------------------------------
.// relate using statements
.// --------------------------------------------------------
.function smt_relate_usings
  .select many act_rus from instances of ACT_RU
  .for each act_ru in act_rus
    .invoke smt_relate_using( act_ru )
  .end for
.end function
.//
.// --------------------------------------------------------
.// relate using statement
.// --------------------------------------------------------
.function smt_relate_using
  .param inst_ref act_ru
  .select one te_smt related by act_ru->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one r_rel related by act_ru->R_REL[R654]
  .invoke is_refl = is_reflexive( r_rel )
  .assign one_rel_phrase = ""
  .assign oth_rel_phrase = ""
  .if ( is_refl.result )
    .select one aone related by r_rel->R_ASSOC[R206]->R_AONE[R209]
    .select one aoth related by r_rel->R_ASSOC[R206]->R_AOTH[R210]
    .select one one_obj related by act_ru->V_VAR[R617]->V_INT[R814]->O_OBJ[R818]
    .if ( one_obj.Obj_ID == aone.Obj_ID )
      .if ( aone.Txt_Phrs == act_ru.relationship_phrase )
        .assign one_rel_phrase = aone.Txt_Phrs
        .assign oth_rel_phrase = aoth.Txt_Phrs
      .else
        .assign one_rel_phrase = aoth.Txt_Phrs
        .assign oth_rel_phrase = aone.Txt_Phrs
      .end if
    .else
      .if ( aoth.Txt_Phrs == act_ru.relationship_phrase )
        .assign one_rel_phrase = aoth.Txt_Phrs
        .assign oth_rel_phrase = aone.Txt_Phrs
      .else
        .assign one_rel_phrase = aone.Txt_Phrs
        .assign oth_rel_phrase = aoth.Txt_Phrs
      .end if
    .end if
  .end if
  .select one one_v_var related by act_ru->V_VAR[R617]
  .select one one_te_var related by one_v_var->TE_VAR[R2039]
  .select one one_o_obj related by one_v_var->V_INT[R814]->O_OBJ[R818]
  .select one oth_v_var related by act_ru->V_VAR[R618]
  .select one oth_te_var related by oth_v_var->TE_VAR[R2039]
  .select one oth_o_obj related by oth_v_var->V_INT[R814]->O_OBJ[R818]
  .select one ass_v_var related by act_ru->V_VAR[R619]
  .select one ass_te_var related by ass_v_var->TE_VAR[R2039]
  .select one ass_o_obj related by ass_v_var->V_INT[R814]->O_OBJ[R818]
  .invoke s = t_oal_smt_relate_using( one_o_obj, oth_o_obj, ass_o_obj, r_rel, is_refl.result, r_rel.Numb, act_ru.relationship_phrase, one_te_var.buffer, oth_te_var.buffer, ass_te_var.buffer, one_rel_phrase, oth_rel_phrase, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "RELATE ${one_v_var.Name} TO ${oth_v_var.Name} ACROSS R${r_rel.Numb} USING ${ass_v_var.Name}"
.end function
.//
.// --------------------------------------------------------
.// unrelate statements
.// --------------------------------------------------------
.function smt_unrelates
  .select many act_unrs from instances of ACT_UNR
  .for each act_unr in act_unrs
    .invoke result = smt_unrelate( act_unr ) 
  .end for
.end function
.//
.// --------------------------------------------------------
.// unrelate statement
.// --------------------------------------------------------
.function smt_unrelate
  .param inst_ref act_unr
  .select one te_smt related by act_unr->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one one_v_var related by act_unr->V_VAR[R620]
  .select one one_te_var related by one_v_var->TE_VAR[R2039]
  .select one one_o_obj related by one_v_var->V_INT[R814]->O_OBJ[R818]
  .select one te_class related by one_o_obj->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .select one oth_v_var related by act_unr->V_VAR[R621]
    .select one oth_te_var related by oth_v_var->TE_VAR[R2039]
    .select one oth_o_obj related by oth_v_var->V_INT[R814]->O_OBJ[R818]
    .select one r_rel related by act_unr->R_REL[R655]
    .invoke is_refl = is_reflexive( r_rel )
    .invoke s = t_oal_smt_unrelate( one_o_obj, oth_o_obj, r_rel, is_refl.result, r_rel.Numb, act_unr.relationship_phrase, one_te_var.buffer, oth_te_var.buffer, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "UNRELATE ${one_te_var.OAL} FROM ${oth_te_var.OAL} ACROSS R${r_rel.Numb}"
  .end if
.end function
.//
.// --------------------------------------------------------
.// unrelate using statements
.// --------------------------------------------------------
.function smt_unrelate_usings
  .select many act_urus from instances of ACT_URU
  .for each act_uru in act_urus
    .invoke smt_unrelate_using( act_uru )
  .end for
.end function
.//
.function smt_unrelate_using
  .param inst_ref act_uru
  .select one te_smt related by act_uru->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one r_rel related by act_uru->R_REL[R656]
  .invoke is_refl = is_reflexive( r_rel )
  .assign one_rel_phrase = ""
  .assign oth_rel_phrase = ""
  .if ( is_refl.result )
    .select one aone related by r_rel->R_ASSOC[R206]->R_AONE[R209]
    .select one aoth related by r_rel->R_ASSOC[R206]->R_AOTH[R210]
    .select one one_obj related by act_uru->V_VAR[R622]->V_INT[R814]->O_OBJ[R818]
    .if ( one_obj.Obj_ID == aone.Obj_ID )
      .if ( aone.Txt_Phrs == act_uru.relationship_phrase )
        .assign one_rel_phrase = aone.Txt_Phrs
        .assign oth_rel_phrase = aoth.Txt_Phrs
      .else
        .assign one_rel_phrase = aoth.Txt_Phrs
        .assign oth_rel_phrase = aone.Txt_Phrs
      .end if
    .else
      .if ( aoth.Txt_Phrs == act_uru.relationship_phrase )
        .assign one_rel_phrase = aoth.Txt_Phrs
        .assign oth_rel_phrase = aone.Txt_Phrs
      .else
        .assign one_rel_phrase = aone.Txt_Phrs
        .assign oth_rel_phrase = aoth.Txt_Phrs
      .end if
    .end if
  .end if
  .select one one_v_var related by act_uru->V_VAR[R622]
  .select one one_te_var related by one_v_var->TE_VAR[R2039]
  .select one oth_v_var related by act_uru->V_VAR[R623]
  .select one oth_te_var related by oth_v_var->TE_VAR[R2039]
  .select one ass_v_var related by act_uru->V_VAR[R624]
  .select one ass_te_var related by ass_v_var->TE_VAR[R2039]
  .select one one_o_obj related by one_v_var->V_INT[R814]->O_OBJ[R818]
  .select one oth_o_obj related by oth_v_var->V_INT[R814]->O_OBJ[R818]
  .select one ass_o_obj related by ass_v_var->V_INT[R814]->O_OBJ[R818]
  .invoke s = t_oal_smt_unrelate_using( one_o_obj, oth_o_obj, ass_o_obj, r_rel, is_refl.result, r_rel.Numb, act_uru.relationship_phrase, one_te_var.buffer, oth_te_var.buffer, ass_te_var.buffer, one_rel_phrase, oth_rel_phrase, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "UNRELATE ${one_te_var.OAL} FROM ${oth_te_var.OAL} ACROSS R${r_rel.Numb} USING ${ass_te_var.OAL}"
.end function
.//
.// --------------------------------------------------------
.// select statements
.// --------------------------------------------------------
.function smt_selects
  .select many act_fios from instances of ACT_FIO
  .for each act_fio in act_fios
    .invoke smt_select( act_fio )
  .end for
.end function
.//
.// --------------------------------------------------------
.// select instance statement
.// --------------------------------------------------------
.function smt_select
  .param inst_ref act_fio
  .select any te_select from instances of TE_SELECT
  .select one te_smt related by act_fio->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one o_obj related by act_fio->O_OBJ[R677]
  .select one te_class related by o_obj->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .select one v_var related by act_fio->V_VAR[R639]
    .select one te_var related by v_var->TE_VAR[R2039]
    .//.assign te_select.o_obj = o_obj
    .assign te_select.is_implicit = act_fio.is_implicit
    .assign te_select.class_name = te_class.GeneratedName
    .assign te_select.target_class_name = o_obj.Name
    .assign te_select.class_description = o_obj.Descrip
    .assign te_select.multiplicity = act_fio.cardinality
    .assign te_select.var_name = te_var.buffer
    .invoke s = t_oal_smt_select( o_obj, te_smt, te_select, te_blk.indentation )
    .assign te_smt.declaration = s.declaration
    .assign te_smt.deallocation = s.deallocation
    .// Push deallocation into the block so that it is available at gen time for break/continue/return.
    .assign te_blk.deallocation = te_blk.deallocation + te_smt.deallocation
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "SELECT ${act_fio.cardinality} ${v_var.Name} FROM INSTANCES OF ${o_obj.Key_Lett}"
  .end if
.end function
.//
.// --------------------------------------------------------
.// select instance where statements
.// --------------------------------------------------------
.function smt_select_wheres
  .select many act_fiws from instances of ACT_FIW
  .for each act_fiw in act_fiws
    .invoke smt_select_where( act_fiw )
  .end for
.end function
.//
.//
.//
.// Recursively drill down into the where clause expression marking
.// selected attributes along the way.
.//
.function v_val_find_v_slr_return_buffer
  .param inst_ref v_val
  .assign attr_slrname = "selected"
  .assign attr_found = false
  .select one v_slr related by v_val->V_SLR[R801]
  .if ( not_empty v_slr )
    .select one te_val related by v_val->TE_VAL[R2040]
    .assign attr_slrname = te_val.buffer
    .assign attr_found = true
  .else
    .select one v_avl related by v_val->V_AVL[R801]
    .if ( not_empty v_avl )
      .select one root_v_val related by v_avl->V_VAL[R807]
      .invoke r = v_val_find_v_slr_return_buffer( root_v_val )
      .assign attr_slrname = r.slrname
      .assign attr_found = true
    .else
    .select one v_bin related by v_val->V_BIN[R801]
    .if ( not_empty v_bin )
      .select one left_v_val related by v_bin->V_VAL[R802]
      .invoke r = v_val_find_v_slr_return_buffer( left_v_val )
      .if ( not r.found )
        .select one right_v_val related by v_bin->V_VAL[R803]
        .invoke r = v_val_find_v_slr_return_buffer( right_v_val )
      .end if
      .assign attr_slrname = r.slrname
      .assign attr_found = true
    .else
    .select one v_uny related by v_val->V_BIN[R801]
    .if ( not_empty v_uny )
      .select one uny_v_val related by v_uny->V_VAL[R804]
      .invoke r = v_val_find_v_slr_return_buffer( uny_v_val )
      .assign attr_slrname = r.slrname
      .assign attr_found = true
    .end if
    .end if
    .end if
  .end if
.end function
.// --------------------------------------------------------
.// select instance where statement
.// --------------------------------------------------------
.function smt_select_where
  .param inst_ref act_fiw
  .select any te_select_where from instances of TE_SELECT_WHERE
  .select one te_smt related by act_fiw->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one o_obj related by act_fiw->O_OBJ[R676]
  .select one te_class related by o_obj->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .select one v_var related by act_fiw->V_VAR[R665]
    .select one te_var related by v_var->TE_VAR[R2039]
    .select any where_v_val related by act_fiw->V_VAL[R610]
    .select any where_te_val related by where_v_val->TE_VAL[R2040]
    .invoke r = v_val_find_v_slr_return_buffer( where_v_val )
    .assign oid_id = -1
    .//.assign te_select_where.o_obj = o_obj
    .assign te_select_where.is_implicit = act_fiw.is_implicit
    .assign te_select_where.class_name = te_class.GeneratedName
    .assign te_select_where.oal_var_name = o_obj.Name
    .assign te_select_where.class_description = o_obj.Descrip
    .assign te_select_where.multiplicity = act_fiw.cardinality
    .assign te_select_where.var_name = te_var.buffer
    .assign te_select_where.selected_var_name = r.slrname
    .assign te_select_where.where_clause = where_te_val.buffer
    .assign te_select_where.special = false
    .assign te_select_where.oid_id = oid_id
    .invoke s = t_oal_smt_select_where( o_obj, te_smt, te_select_where, te_blk.indentation )
    .assign te_smt.declaration = s.declaration
    .assign te_smt.deallocation = s.deallocation
    .// Push deallocation into the block so that it is available at gen time for break/continue/return.
    .assign te_blk.deallocation = te_blk.deallocation + te_smt.deallocation
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "SELECT ${act_fiw.cardinality} ${v_var.Name} FROM INSTANCES OF ${o_obj.Key_Lett} WHERE ${where_te_val.OAL}"
  .end if
.end function
.// --------------------------------------------------------
.// select instance related by statement
.// --------------------------------------------------------
.function smt_select_relateds
  .select many act_srs from instances of ACT_SR
  .for each act_sr in act_srs
    .select one act_sel related by act_sr->ACT_SEL[R664]
    .invoke smt_select_related( act_sel, false )
  .end for
.end function
.//
.// --------------------------------------------------------
.// select related by where statements
.// --------------------------------------------------------
.function smt_select_related_wheres
  .select many act_srws from instances of ACT_SRW
  .for each act_srw in act_srws
    .select one act_sel related by act_srw->ACT_SEL[R664]
    .invoke smt_select_related( act_sel, true )
  .end for
.end function
.//
.// --------------------------------------------------------
.// generate pre-created event statements
.// --------------------------------------------------------
.function smt_generate_precreated_events
  .select many e_gprs from instances of E_GPR
  .for each e_gpr in e_gprs
    .invoke smt_generate_precreated_event( e_gpr )
  .end for
.end function
.//
.function smt_generate_precreated_event
  .param inst_ref e_gpr
  .select one te_smt related by e_gpr->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one te_val related by e_gpr->V_VAL[R714]->TE_VAL[R2040]
  .// May need to do some investigating to see how to tell if
  .// this event is self-directed or not.
  .assign self_directed = false
  .// Also may need to dig inside, get the sm_evt and then see if this
  .// event is polymorphic.
  .invoke s = t_oal_smt_generate_precreated_event( self_directed, te_val.buffer, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "GENERATE ${te_val.OAL}"
.end function
.//
.//
.// --------------------------------------------------------
.// generate event statements
.// --------------------------------------------------------
.function smt_generate_events
  .select many e_gens from instances of E_GEN
  .for each e_gen in e_gens
    .invoke smt_generate_event( e_gen )
  .end for
.end function
.//
.function print_v_pars
  .param inst_ref v_par
  .assign done = false
  .while ( not done )
    .if ( empty v_par )
      .assign done = true
    .else
      .print "-=-=-=-=-=-=-=-=-=-=-=-=-=- v_par is ${v_par.Name}"
      .select one sm_evtdi related by v_par->V_VAL[R800]->V_EDV[R801]->V_EPR[R834]->SM_EVTDI[R846]
      .if (not_empty sm_evtdi)
      .print "-=m=m=m=-=-=-=-=-=-=-=-=-=- sm_evtdi is ${sm_evtdi.Name}"
      .end if
      .select one v_par related by v_par->V_PAR[R816.'succeeds']
    .end if
  .end while
.end function
.//
.function smt_generate_event
  .param inst_ref e_gen
  .select one e_gsme related by e_gen->E_GSME[R705]
  .select one e_ess related by e_gsme->E_GES[R703]->E_ESS[R701]
  .select one act_smt related by e_ess->ACT_SMT[R603]
  .select one te_smt related by act_smt->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one sm_evt related by e_gsme->SM_EVT[R707]
  .select one v_var related by e_gen->V_VAR[R712]
  .select one te_var related by v_var->TE_VAR[R2039]
  .select any te_class related by sm_evt->SM_SM[R502]->SM_ISM[R517]->O_OBJ[R518]->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .assign te_class.Included = TRUE
    .select many v_pars related by e_ess->V_PAR[R700]
    .assign parameters = ""
    .assign parameter_OAL = ""
    .if ( not_empty v_pars )
      .assign delimeter = ""
      .for each v_par in v_pars
        .select one par_te_dt related by v_par->V_VAL[R800]->S_DT[R820]->TE_DT[R2021]
        .select one par_te_val related by v_par->V_VAL[R800]->TE_VAL[R2040]
        .invoke r = t_oal_smt_event_parameters( "", v_par.Name, par_te_val.buffer, par_te_dt.Core_Typ, te_blk.indentation )
        .assign parameters = parameters + r.result
        .assign parameter_OAL = ( parameter_OAL + delimeter ) + par_te_val.OAL
        .assign delimeter = ", "
      .end for
    .end if
    .assign self_directed = false
    .if ( "self" == "$l{v_var.Name}" )
      .assign self_directed = true
    .end if
    .invoke s = t_oal_smt_generate( sm_evt, self_directed, te_var.buffer, sm_evt.Drv_Lbl, sm_evt.Mning, parameters, te_blk.indentation )
    .assign te_smt.declaration = s.declaration
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "GENERATE ${sm_evt.Drv_Lbl}:${sm_evt.Mning}(${parameter_OAL}) TO ${v_var.Name}"
  .end if
.end function
.//
.// --------------------------------------------------------
.// generate creator event statement
.// --------------------------------------------------------
.function smt_generate_creator_events
  .select many e_gecs from instances of E_GEC
  .for each e_gec in e_gecs
    .invoke smt_generate_creator_event( e_gec )
  .end for
.end function
.//
.function smt_generate_creator_event
  .param inst_ref e_gec
  .select one te_smt related by e_gec->E_GSME[R705]->E_GES[R703]->E_ESS[R701]->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .invoke p = smt_generate_class_event( e_gec )
  .if ( p.valid )
    .assign sm_evt = p.sm_evt
    .assign tgt_o_obj = p.tgt_o_obj
    .invoke s = t_oal_smt_generate_creator_event( p.sm_evt, p.self_directed, "0", sm_evt.Drv_Lbl, sm_evt.Mning, p.parameters, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "GENERATE ${sm_evt.Drv_Lbl}:${sm_evt.Mning}(${p.parameter_OAL}) TO ${tgt_o_obj.Key_Lett} CREATOR"
  .end if
.end function
.//
.// --------------------------------------------------------
.// generate class event statement
.// --------------------------------------------------------
.function smt_generate_class_events
  .select many e_gars from instances of E_GAR
  .for each e_gar in e_gars
    .invoke smt_generate_event_to_class( e_gar )
  .end for
.end function
.//
.function smt_generate_event_to_class
  .param inst_ref act_smt
  .select one te_smt related by act_smt->E_GSME[R705]->E_GES[R703]->E_ESS[R701]->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .invoke p = smt_generate_class_event( act_smt )
  .if ( p.valid )
    .assign sm_evt = p.sm_evt
    .assign tgt_o_obj = p.tgt_o_obj
    .invoke s = t_oal_smt_generate_to_class( p.sm_evt, p.self_directed, "0", sm_evt.Drv_Lbl, sm_evt.Mning, p.parameters, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "GENERATE ${sm_evt.Drv_Lbl}:${sm_evt.Mning}(${p.parameter_OAL}) TO ${tgt_o_obj.Key_Lett} CLASS"
  .end if
.end function
.//
.function smt_generate_class_event
  .param inst_ref e_gar
  .assign attr_parameters = ""
  .assign attr_parameter_OAL = ""
  .assign attr_self_directed = false
  .assign attr_valid = false
  .select one e_ess related by e_gar->E_GSME[R705]->E_GES[R703]->E_ESS[R701]
  .select one te_smt related by e_ess->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one act_act related by e_ess->ACT_SMT[R603]->ACT_BLK[R602]->ACT_ACT[R601]
  .select one act_sab related by act_act->ACT_SAB[R698]
  .select one attr_sm_evt related by e_gar->E_GSME[R705]->SM_EVT[R707]
  .select one o_obj related by act_sab->SM_ACT[R691]->SM_SM[R515]->SM_ISM[R517]->O_OBJ[R518]
  .if ( empty o_obj )
    .select one o_obj related by act_sab->SM_ACT[R691]->SM_SM[R515]->SM_ASM[R517]->O_OBJ[R519]
  .end if
  .select any attr_tgt_o_obj related by attr_sm_evt->SM_SM[R502]->SM_ISM[R517]->O_OBJ[R518]
  .if ( empty attr_tgt_o_obj )
    .select any attr_tgt_o_obj related by attr_sm_evt->SM_SM[R502]->SM_ASM[R517]->O_OBJ[R519]
  .end if
  .select one te_class related by attr_tgt_o_obj->TE_CLASS[R2019]
  .if ( not_empty te_class )
    .assign te_class.Included = TRUE
    .assign attr_valid = true
    .if ( act_act.Type == "state" )
      .if ( o_obj == attr_tgt_o_obj )
        .assign attr_self_directed = true
      .end if
    .elif ( act_act.Type == "transition" )
      .if ( o_obj == attr_tgt_o_obj )
        .assign attr_self_directed = true
      .end if
    .end if
    .select many v_pars related by e_ess->V_PAR[R700]
    .if ( not_empty v_pars )
      .assign delimeter = ""
      .for each v_par in v_pars
        .select one par_te_dt related by v_par->V_VAL[R800]->S_DT[R820]->TE_DT[R2021]
        .select one par_te_val related by v_par->V_VAL[R800]->TE_VAL[R2040]
        .invoke r = t_oal_smt_event_parameters( "", v_par.Name, par_te_val.buffer, par_te_dt.Core_Typ, te_blk.indentation )
        .assign attr_parameters = attr_parameters + r.result
        .assign attr_parameter_OAL = ( attr_parameter_OAL + delimeter ) + par_te_val.OAL
        .assign delimeter = ", "
      .end for
    .end if
  .end if
.end function
.//
.// --------------------------------------------------------
.// inter-component interface signal
.// --------------------------------------------------------
.function smt_sgns
  .select many act_sgns from instances of ACT_SGN
  .for each act_sgn in act_sgns
    .invoke smt_sgn( act_sgn )
  .end for
.end function
.//
.function smt_sgn
  .param inst_ref act_sgn
  .select one te_smt related by act_sgn->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one te_mact related by act_sgn->SPR_PS[R663]->TE_MACT[R2051]
  .if ( empty te_mact )
    .select one te_mact related by act_sgn->SPR_RS[R660]->TE_MACT[R2053]
  .end if
  .select many v_pars related by act_sgn->V_PAR[R662]
  .invoke rm = q_render_msg( te_mact, v_pars, te_blk.indentation, true )
  .assign te_smt.buffer = rm.smt_buffer
  .assign te_smt.OAL = " SEND ${te_mact.PortName}::${te_mact.MessageName}(${rm.parameter_OAL})"
.end function
.//
.// --------------------------------------------------------
.// inter-component interface operation
.// --------------------------------------------------------
.function smt_iops
  .select many act_iops from instances of ACT_IOP
  .for each act_iop in act_iops
    .invoke smt_iop( act_iop )
  .end for
.end function
.//
.function smt_iop
  .param inst_ref act_iop
  .select one te_smt related by act_iop->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one te_mact related by act_iop->SPR_RO[R657]->TE_MACT[R2052]
  .if ( empty te_mact )
    .select one te_mact related by act_iop->SPR_PO[R680]->TE_MACT[R2050]
  .end if
  .select many v_pars related by act_iop->V_PAR[R679]
  .invoke rm = q_render_msg( te_mact, v_pars, te_blk.indentation, true )
  .assign te_smt.buffer = rm.smt_buffer
  .assign te_smt.OAL = "${te_mact.PortName}::${te_mact.MessageName}(${rm.parameter_OAL})"
.end function
.//
.// -------------------------------------------------------------------
.// Render the call and parameter list for an inter-component message
.// -------------------------------------------------------------------
.function q_render_msg
  .param inst_ref te_mact
  .param inst_ref_set v_pars
  .param string ws
  .param boolean is_statement
  .select any te_sys from instances of TE_SYS
  .select any te_target from instances of TE_TARGET
  .assign parameters = ""
  .assign attr_parameter_OAL = ""
  .assign attr_smt_buffer = ""
  .if ( not_empty v_pars )
    .invoke r = gen_parameter_list( v_pars, false, "message" )
    .assign parameters = r.body
    .assign attr_parameter_OAL = r.result
  .end if
  .assign name = te_mact.GeneratedName
  .if ( "SystemC" == te_target.language )
    .// Now navigate out across the satisfaction to get the port index of the
    .// foreign component (instance).
    .select one te_po related by te_mact->TE_PO[R2006]
    .assign foreign_te_po = te_po
    .if ( te_po.Provision )
      .if ( 1 == te_mact.Direction )
        .assign name = ( te_mact.PortName + "->" ) + name
      .end if
      .select any foreign_te_po related by te_po->TE_IIR[R2080]->TE_IIR[R2081.'requires or delegates']->TE_PO[R2080] where ( ( selected.PackageName == te_po.PackageName ) and ( selected.ID != te_po.ID ) )
    .else
      .if ( 0 == te_mact.Direction )
        .assign name = ( te_mact.PortName + "->" ) + name
      .end if
      .select any foreign_te_po related by te_po->TE_IIR[R2080]->TE_IIR[R2081.'provides or is delegated']->TE_PO[R2080] where ( ( selected.PackageName == te_po.PackageName ) and ( selected.ID != te_po.ID ) )
    .end if
    .assign name = "thismodule->" + name
    .if ( not_empty foreign_te_po )
      .if ( foreign_te_po.polymorphic )
        .if ( "" != parameters )
          .assign parameters = ", " + parameters
        .end if
        .assign parameters = "${foreign_te_po.sibling}" + parameters
      .end if
    .elif( te_sys.AllPortsPoly == true )
      .if ( "" != parameters )
        .assign parameters = ", " + parameters
      .end if
      .assign parameters = "0" + parameters
    .end if
  .end if
  .invoke s = t_oal_smt_iop( name, parameters, ws, is_statement )
  .assign attr_smt_buffer = s.body
.end function
.//
.// --------------------------------------------------------
.// class operation statement
.// --------------------------------------------------------
.function smt_operates
  .select many act_tfms from instances of ACT_TFM
  .for each act_tfm in act_tfms
    .invoke smt_operate( act_tfm )
  .end for
.end function
.//
.function smt_operate
  .param inst_ref act_tfm
  .select any te_target from instances of TE_TARGET
  .select one te_smt related by act_tfm->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one te_var related by act_tfm->V_VAR[R667]->TE_VAR[R2039]
  .select one o_tfr related by act_tfm->O_TFR[R673]
  .select one te_tfr related by o_tfr->TE_TFR[R2024]
  .if ( not_empty te_tfr )
    .select one o_obj related by o_tfr->O_OBJ[R115]
    .assign variable = ""
    .assign instance_based = false
    .if ( o_tfr.Instance_Based == 1 )
      .assign instance_based = true
      .assign variable = te_var.buffer
    .end if
    .assign parameters = ""
    .assign parameter_OAL = ""
    .select many v_pars related by act_tfm->V_PAR[R627]
    .if ( not_empty v_pars )
      .invoke r = gen_parameter_list( v_pars, false, "operation" )
      .assign parameters = r.body
      .assign parameter_OAL = r.result
    .end if
    .assign name = te_tfr.GeneratedName
    .assign uses_thismodule = false
    .if ( ( "SystemC" == te_target.language ) or ( "C++" == te_target.language ) )
      .assign uses_thismodule = true
      .if ( not instance_based )
        .select one te_class related by o_obj->TE_CLASS[R2019]
        .assign name = ( te_class.GeneratedName + "::" ) + te_tfr.GeneratedName
      .end if
    .end if
    .invoke s = t_oal_smt_operation( instance_based, name, parameters, variable, uses_thismodule, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .if ( instance_based )
      .assign te_smt.OAL = ( te_var.OAL + "." ) + ( te_tfr.Name + "(" )
    .else
      .assign te_smt.OAL = ( o_obj.Key_Lett + "::" ) + ( te_tfr.Name + "(" )
    .end if
    .if ( "" != parameter_OAL )
      .assign te_smt.OAL = ( te_smt.OAL + " " ) + ( parameter_OAL + " " )
    .end if
    .assign te_smt.OAL = te_smt.OAL + ")"
  .end if
.end function
.//
.// --------------------------------------------------------
.// bridge statement
.// --------------------------------------------------------
.function smt_bridges
  .select many act_brgs from instances of ACT_BRG
  .for each act_brg in act_brgs
    .invoke result = smt_bridge( act_brg )
  .end for
.end function
.//
.function smt_bridge
  .param inst_ref act_brg
  .select any te_target from instances of TE_TARGET
  .select one te_smt related by act_brg->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one s_brg related by act_brg->S_BRG[R674]
  .select one te_brg related by s_brg->TE_BRG[R2025]
  .if ( not_empty te_brg )
    .select one te_ee related by s_brg->S_EE[R19]->TE_EE[R2020]
    .assign te_ee.Included = true
    .select many v_pars related by act_brg->V_PAR[R628]
    .invoke r = gen_parameter_list( v_pars, false, "bridge" )
    .assign parameters = r.body
    .assign parameter_OAL = r.result
    .assign name = te_brg.GeneratedName
    .if ( ( "SystemC" == te_target.language ) or ( "C++" == te_target.language ) )
      .assign name = ( te_ee.RegisteredName + "::" ) + name
      .select one te_c related by te_ee->TE_C[R2085]
      .if ( ( "TIM" != te_brg.EEkeyletters ) and ( not_empty te_c ) )
        .if ( "" == parameters )
          .assign parameters = "thismodule"
        .else
          .assign parameters = "thismodule, " + parameters
        .end if
      .end if
    .end if
    .invoke s = t_oal_smt_bridge( te_brg, name, parameters, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "${te_brg.EEkeyletters}::${te_brg.Name}( ${parameter_OAL} )"
  .end if
.end function
.//
.// --------------------------------------------------------
.// function statement
.// --------------------------------------------------------
.function smt_functions
  .select many act_fncs from instances of ACT_FNC
  .for each act_fnc in act_fncs
    .invoke result = smt_function( act_fnc )
  .end for
.end function
.//
.function smt_function
  .param inst_ref act_fnc
  .//
  .select any te_target from instances of TE_TARGET
  .select one te_smt related by act_fnc->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one te_sync related by act_fnc->S_SYNC[R675]->TE_SYNC[R2023]
  .if ( not_empty te_sync )
    .assign parameters = ""
    .assign parameter_OAL = ""
    .select many v_pars related by act_fnc->V_PAR[R669]
    .if ( not_empty v_pars )
      .invoke r = gen_parameter_list( v_pars, false, "function" )
      .assign parameters = r.body
      .assign parameter_OAL = r.result
    .end if
    .assign name = te_sync.intraface_method
    .if ( "SystemC" == te_target.language )
      .assign name = "thismodule->" + name
    .end if
    .invoke s = t_oal_smt_function( name, parameters, te_blk.indentation )
    .assign te_smt.buffer = s.body
    .assign te_smt.OAL = "::${te_sync.Name}( ${parameter_OAL} )"
  .end if
.end function
.//
.// --------------------------------------------------------
.// return statements
.// --------------------------------------------------------
.function smt_returns
.select many act_rets from instances of ACT_RET
.for each act_ret in act_rets
  .invoke smt_return( act_ret )
.end for
.end function
.//
.// --------------------------------------------------------
.// return statement
.// --------------------------------------------------------
.function smt_return
  .param inst_ref act_ret
  .select one te_smt related by act_ret->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one v_val related by act_ret->V_VAL[R668]
  .assign intCast1 = ""
  .assign intCast2 = ""
  .assign value = ""
  .assign value_OAL = ""
  .assign returnvaltype = ""
  .if (not_empty v_val)
    .//
    .// resolve the core data type of v_val
    .select one s_dt related by v_val->S_DT[R820]
    .assign return_s_dt = s_dt
    .select any core_s_dt from instances of S_DT where ( false )
    .select one s_udt related by s_dt->S_UDT[R17]
    .if ( not_empty s_udt )
      .invoke r = GetBaseTypeForUDT( s_udt )
      .assign core_s_dt = r.result
    .end if
    .if (not_empty core_s_dt)
      .assign s_dt = core_s_dt
    .end if
    .select one te_dt related by s_dt->TE_DT[R2021]
    .assign returnvaltype = te_dt.ExtName
    .//
    .// if the value is of the _real_ type
    .if (s_dt.Name == "real")
      .// if we can resolve the name of the data type of the return type of the enclosing body
      .select one act_smt related by act_ret->ACT_SMT[R603]
      .// Get the return _statement_ data type name.
      .select one act_act related by act_smt->ACT_BLK[R602]->ACT_ACT[R601]
      .// "class transition", "transition", "class state", "state", "signal" use void
      .assign return_smt_dt_name = "void"
      .if ( (act_act.Type == "class operation") or (act_act.Type == "operation") )
        .select one return_s_dt related by act_act->ACT_OPB[R698]->O_TFR[R696]->S_DT[R116]
        .assign return_smt_dt_name = return_s_dt.Name
      .elif ( act_act.Type == "function" )
        .select one return_s_dt related by act_act->ACT_FNB[R698]->S_SYNC[R695]->S_DT[R25]
        .assign return_smt_dt_name = return_s_dt.Name
      .elif ( act_act.Type == "interface operation" )
        .select one return_s_dt related by act_act->ACT_ROB[R698]->SPR_RO[R685]->SPR_REP[R4502]->C_EP[R4500]->C_IO[R4004]->S_DT[R4008]
        .if ( empty return_s_dt )
          .select one return_s_dt related by act_act->ACT_POB[R698]->SPR_PO[R687]->SPR_PEP[R4503]->C_EP[R4501]->C_IO[R4004]->S_DT[R4008]
        .end if
        .assign return_smt_dt_name = return_s_dt.Name
      .elif ( act_act.Type == "bridge" )
        .select one return_s_dt related by act_act->ACT_BRB[R698]->S_BRG[R697]->S_DT[R20]
        .assign return_smt_dt_name = return_s_dt.Name
      .end if
      .if ( return_smt_dt_name != "" )
        .// resolve the core type of the return type
        .select any core_s_dt from instances of S_DT where ( false )
        .select one s_udt related by return_s_dt->S_UDT[R17]
        .if ( not_empty s_udt )
          .invoke i = GetBaseTypeForUDT( s_udt )
          .assign core_s_dt = i.result
        .end if
        .if (not_empty core_s_dt)
          .assign return_s_dt = core_s_dt
        .end if
        .//
        .// if the return type is integer
        .if ( "integer" == return_s_dt.Name )
          .// cast the value to an int, to avoid a "possible loss of precision"
          .// syntax error in the generated code
          .assign intCast1 = "(int)("
          .assign intCast2 = ")"
        .end if
      .end if
    .end if 
    .select one te_val related by v_val->TE_VAL[R2040]
    .assign value = te_val.buffer
    .assign value_OAL = te_val.OAL
  .end if
  .// Deallocate any variables allocated from this block and all higher blocks in this action.
  .assign deallocation = te_blk.deallocation
  .select one parent_te_blk related by te_blk->TE_SMT[R2015]->TE_BLK[R2078]
  .while ( not_empty parent_te_blk )
    .assign deallocation = deallocation + parent_te_blk.deallocation
    .select one parent_te_blk related by parent_te_blk->TE_SMT[R2015]->TE_BLK[R2078]
  .end while
  .//
  .invoke s = t_oal_smt_return( value, returnvaltype, intCast1, intCast2, deallocation, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "RETURN ${value_OAL}"
.end function
.//
.// --------------------------------------------------------
.// control statements
.// --------------------------------------------------------
.function smt_controls
.select many act_ctls from instances of ACT_CTL
.for each act_ctl in act_ctls
  .invoke smt_control( act_ctl )
.end for
.end function
.//
.// --------------------------------------------------------
.// control statement
.// --------------------------------------------------------
.function smt_control
  .param inst_ref act_ctl
  .select one te_smt related by act_ctl->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .invoke s = t_oal_smt_control( te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "CONTROL"
.end function
.//
.// --------------------------------------------------------
.// break statements
.// --------------------------------------------------------
.function smt_breaks
  .select many act_brks from instances of ACT_BRK
  .for each act_brk in act_brks
    .invoke smt_break( act_brk )
  .end for
.end function
.//
.// --------------------------------------------------------
.// break statement
.// --------------------------------------------------------
.function smt_break
  .param inst_ref act_brk
  .select one te_smt related by act_brk->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .// Deallocate any variables allocated from this block and higher blocks up to containing WHILE or FOR.
  .assign deallocation = te_blk.deallocation
  .select one parent_te_blk related by te_blk->TE_SMT[R2015]->TE_BLK[R2078]
  .while ( not_empty parent_te_blk )
    .select one parent_te_smt related by parent_te_blk->TE_SMT[R2015]
    .if ( not_empty parent_te_smt )
      .assign deallocation = deallocation + parent_te_blk.deallocation
      .if ( ( "TE_WHL" == parent_te_smt.subtypeKL ) or ( "TE_FOR" == parent_te_smt.subtypeKL ) )
        .break while
      .end if
    .end if
    .select one parent_te_blk related by parent_te_smt->TE_BLK[R2078]
  .end while
  .invoke s = t_oal_smt_break( deallocation, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "BREAK"
.end function
.//
.// --------------------------------------------------------
.// continue statements
.// --------------------------------------------------------
.function smt_continues
  .select many act_cons from instances of ACT_CON
  .for each act_con in act_cons
    .invoke smt_continue( act_con )
  .end for
.end function
.//
.// --------------------------------------------------------
.// continue statement
.// --------------------------------------------------------
.function smt_continue
  .param inst_ref act_con
  .select one te_smt related by act_con->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .// Deallocate any variables allocated from this block and higher blocks up to containing WHILE or FOR.
  .assign deallocation = te_blk.deallocation
  .select one parent_te_blk related by te_blk->TE_SMT[R2015]->TE_BLK[R2078]
  .while ( not_empty parent_te_blk )
    .select one parent_te_smt related by parent_te_blk->TE_SMT[R2015]
    .if ( not_empty parent_te_smt )
      .assign deallocation = deallocation + parent_te_blk.deallocation
      .if ( ( "TE_WHL" == parent_te_smt.subtypeKL ) or ( "TE_FOR" == parent_te_smt.subtypeKL ) )
        .break while
      .end if
    .end if
    .select one parent_te_blk related by parent_te_smt->TE_BLK[R2078]
  .end while
  .invoke s = t_oal_smt_continue( deallocation, te_blk.indentation )
  .assign te_smt.buffer = s.body
  .assign te_smt.OAL = "CONTINUE"
.end function
.//
.function smt_select_related
  .param inst_ref act_sel
  .param boolean by_where
  .select any te_file from instances of TE_FILE
  .select any te_set from instances of TE_SET
  .select any empty_te_lnk from instances of TE_LNK where ( false )
  .select any empty_act_lnk from instances of ACT_LNK where ( false )
  .select one te_smt related by act_sel->ACT_SMT[R603]->TE_SMT[R2038]
  .select one te_blk related by te_smt->TE_BLK[R2078]
  .select one start_v_val related by act_sel->V_VAL[R613]
  .select one start_te_val related by start_v_val->TE_VAL[R2040]
  .select one start_v_var related by start_v_val->V_IRF[R801]->V_VAR[R808]
  .select one start_o_obj related by start_v_var->V_INT[R814]->O_OBJ[R818]
  .assign start_many = false
  .if ( empty start_v_var )
    .assign start_many = true
    .select one start_v_var related by start_v_val->V_ISR[R801]->V_VAR[R809]
    .select one start_o_obj related by start_v_var->V_INS[R814]->O_OBJ[R819]
  .end if
  .select one start_te_class related by start_o_obj->TE_CLASS[R2019]
  .if ( not_empty start_te_class )
  .// QUERY and POPULATE:  FactoryTE_SELECT_RELATED
  .// Create and link the translation instance for select_related.
  .create object instance te_select_related of TE_SELECT_RELATED
  .assign te_select_related.by_where = by_where
  .assign te_select_related.is_implicit = act_sel.is_implicit
  .assign te_select_related.multiplicity = act_sel.cardinality
  .// relate te_select_related to start_te_class across R2077;
  .assign te_select_related.te_classGeneratedName = start_te_class.GeneratedName
  .// end relate
  .select one start_te_var related by start_v_var->TE_VAR[R2039]
  .assign te_select_related.start_var = start_te_val.buffer
  .assign te_select_related.start_var_OAL = start_te_val.OAL
  .if ( start_many )
    .assign te_select_related.start_many = true
  .end if
  .select one act_lnk related by act_sel->ACT_LNK[R637]
  .select one te_lnk related by act_lnk->TE_LNK[R2042]
  .// Here we detect and insert a link association if we have
  .// traversed directly from aone to aoth (or vice versa) across an
  .// associative association.  Insert the associative link between
  .// the starting variable and the first link in the chain.
  .invoke r = detect_and_insert_associator_TE_LNK( empty_te_lnk, te_lnk, empty_act_lnk, act_lnk, start_o_obj )
  .assign assr_te_lnk = r.result
  .if ( not_empty assr_te_lnk )
    .assign te_lnk = assr_te_lnk
  .end if
  .// We detect first here.  We detect last in primary query/populate.
  .assign te_lnk.first = true
  .// For the first link, the left (set) reference is the link start variable.
  .assign te_lnk.left = te_select_related.start_var
  .select one result_v_var related by act_sel->V_VAR[R638]
  .select one result_te_var related by result_v_var->TE_VAR[R2039]
  .assign te_select_related.result_var = result_te_var.buffer
  .assign te_select_related.result_var_OAL = result_te_var.OAL
  .select one te_class related by result_v_var->V_INT[R814]->O_OBJ[R818]->TE_CLASS[R2019]
  .if ( "many" == te_select_related.multiplicity )
    .select one te_class related by result_v_var->V_INS[R814]->O_OBJ[R819]->TE_CLASS[R2019]
  .end if
  .if ( te_select_related.start_many )
    .assign te_lnk.left = te_select_related.te_classGeneratedName + "_linkage"
  .end if
  .if ( te_select_related.by_where )
    .select one where_te_val related by act_sel->ACT_SRW[R664]->V_VAL[R611]->TE_VAL[R2040]
    .// relate where_te_val to te_select_related across R2074;
    .assign te_select_related.where_clause_Value_ID = where_te_val.Value_ID
    .// end relate
    .assign te_select_related.where_clause = where_te_val.buffer
    .assign te_select_related.where_clause_OAL = where_te_val.OAL
  .end if
  .// relate te_select_related to te_smt across R2069;
  .assign te_select_related.Statement_ID = te_smt.Statement_ID
  .// end relate
  .// relate te_select_related to start_te_val across R2070;
  .assign te_select_related.starting_Value_ID = start_te_val.Value_ID
  .// end relate
  .// relate te_select_related to start_te_var across R2071;
  .assign te_select_related.starting_Var_ID = start_te_var.Var_ID
  .// end relate
  .// relate te_select_related to te_lnk across R2073;
  .assign te_select_related.link_ID = te_lnk.ID
  .// end relate
  .//
  .// RENDER
  .// Truth Table
  .//
  .// Notes:
  .// 1) Selecting "many" or "any" through a chain that has multiplicity 1
  .//    all the way through should not be allowed by the OAL parser.
  .//    However, maybe a parser will not catch it.  Therefore, we will
  .//    support the construct in the code generator.  We will treat it
  .//    like the corresponding "one" case but populate an result set.
  .// 2) Selecting "one" through a chain that has multiplicity M should
  .//    not be allowed by the OAL parser.  However, maybe a parser will
  .//    miss it.  Therefore, we will do something that makes sense.  We
  .//    treat it like the "any" case in the code generator.
  .// 
  .//   A <*----R1----1> B <*----R2----1> C
  .//     <1----R9----*>   <1----R8----*>  
  .// 
  .// single-link chains
  .// Declaration based upon multiplicity.
  .//  #  | first | last | startmany | multiplicity | linkmult | by_where | example
  .//  1  |   T   |  T   |     F     |   "one"      |  0:one   |    F     | select one b related by a->B[R1];
  .//  2  |   T   |  T   |     F     |   "one"      |  0:one   |    T     | select one b related by a->B[R1] where ( selected.i == 7 );
  .//  3  |   T   |  T   |     F     | "one"->"any" |  1:many  |    F     | select one b related by a->B[R9];                              // Note 2
  .//  4  |   T   |  T   |     F     | "one"->"any" |  1:many  |    T     | select one b related by a->B[R9] where ( selected.i == 7 );    // Note 2
  .//  5  |   T   |  T   |     F     |   "any"      |  0:one   |    F     | select any b related by a->B[R1];                              // Note 1
  .//  6  |   T   |  T   |     F     |   "any"      |  0:one   |    T     | select any b related by a->B[R1] where ( selected.i == 7 );    // Note 1
  .//  7  |   T   |  T   |     F     |   "any"      |  1:many  |    F     | select any b related by a->B[R9];
  .//  8  |   T   |  T   |     F     |   "any"      |  1:many  |    T     | select any b related by a->B[R9] where ( selected.i == 7 );
  .//  9  |   T   |  T   |     F     |   "many"     |  0:one   |    F     | select many bs related by a->B[R1];                            // Note 1
  .// 10  |   T   |  T   |     F     |   "many"     |  0:one   |    T     | select many bs related by a->B[R1] where ( selected.i == 7 );  // Note 1
  .// 11  |   T   |  T   |     F     |   "many"     |  1:many  |    F     | select many bs related by a->B[R9];
  .// 12  |   T   |  T   |     F     |   "many"     |  1:many  |    T     | select many bs related by a->B[R9] where ( selected.i == 7 );
  .// 13  |   T   |  T   |     T     | "one"->"any" |  0:one   |    F     | select one b related by as->B[R1];                             // Note 2
  .// 14  |   T   |  T   |     T     | "one"->"any" |  0:one   |    T     | select one b related by as->B[R1] where ( selected.i == 7 );   // Note 2
  .// 15  |   T   |  T   |     T     | "one"->"any" |  1:many  |    F     | select one b related by as->B[R9];                             // Note 2
  .// 16  |   T   |  T   |     T     | "one"->"any" |  1:many  |    T     | select one b related by as->B[R9] where ( selected.i == 7 );   // Note 2
  .// 17  |   T   |  T   |     T     |   "any"      |  0:one   |    F     | select any b related by as->B[R1];
  .// 18  |   T   |  T   |     T     |   "any"      |  0:one   |    T     | select any b related by as->B[R1] where ( selected.i == 7 );
  .// 19  |   T   |  T   |     T     |   "any"      |  1:many  |    F     | select any b related by as->B[R9];
  .// 20  |   T   |  T   |     T     |   "any"      |  1:many  |    T     | select any b related by as->B[R9] where ( selected.i == 7 );
  .// 21  |   T   |  T   |     T     |   "many"     |  0:one   |    F     | select many bs related by as->B[R1];
  .// 22  |   T   |  T   |     T     |   "many"     |  0:one   |    T     | select many bs related by as->B[R1] where ( selected.i == 7 );
  .// 23  |   T   |  T   |     T     |   "many"     |  1:many  |    F     | select many bs related by as->B[R9];
  .// 24  |   T   |  T   |     T     |   "many"     |  1:many  |    T     | select many bs related by as->B[R9] where ( selected.i == 7 );
  .// multi-link chains
  .// Declaration/initialization based upon multiplicity.
  .// First iterator based upon startmany.
  .// Chaining based upon multiplicity (and "any").
  .//  #  | first | last | multiplicity | linkmult | by_where | example
  .//  1m |   T   |  F   |   "one"      |  0:one   |    F     | select one c related by a(s)->B[R1]->C[R2];
  .//  2m |   T   |  F   |   "one"      |  0:one   |    T     | select one c related by a(s)->B[R1]->C[R2] where ( selected.i == 7 );
  .//  3m |   T   |  F   | "one"->"any" |  1:many  |    F     | select one c related by a(s)->B[R9]->C[R8];                              // Note 2
  .//  4m |   T   |  F   | "one"->"any" |  1:many  |    T     | select one c related by a(s)->B[R9]->C[R8] where ( selected.i == 7 );    // Note 2
  .//  5m |   T   |  F   |   "any"      |  0:one   |    F     | select any c related by a(s)->B[R1]->C[R2];                              // Note 1, 2
  .//  6m |   T   |  F   |   "any"      |  0:one   |    T     | select any c related by a(s)->B[R1]->C[R2] where ( selected.i == 7 );    // Note 1, 2
  .//  7m |   T   |  F   |   "any"      |  1:many  |    F     | select any c related by a(s)->B[R9]->C[R8];
  .//  8m |   T   |  F   |   "any"      |  1:many  |    T     | select any c related by a(s)->B[R9]->C[R8] where ( selected.i == 7 );
  .//  9m |   T   |  F   |   "many"     |  0:one   |    F     | select many cs related by a(s)->B[R1]->C[R2];                            // Note 1
  .// 10m |   T   |  F   |   "many"     |  0:one   |    T     | select many cs related by a(s)->B[R1]->C[R2] where ( selected.i == 7 );  // Note 1
  .// 11m |   T   |  F   |   "many"     |  1:many  |    F     | select many cs related by a(s)->B[R9]->C[R8];
  .// 12m |   T   |  F   |   "many"     |  1:many  |    T     | select many cs related by a(s)->B[R9]->C[R8] where ( selected.i == 7 );
  .// 
  .assign ws = te_blk.indentation
  .assign te_smt.OAL = "SELECT ${te_select_related.multiplicity} ${te_select_related.result_var_OAL} RELATED BY ${te_select_related.start_var_OAL}"
  .// declaration
  .assign b = ""
  .if ( te_select_related.is_implicit )
    .if ( "many" == te_select_related.multiplicity )
      .include "${te_file.arc_path}/t.smt_sr.declare_set.c"
      .assign te_smt.declaration = b
      .assign b = ""
      .include "${te_file.arc_path}/t.smt_sr.deallocate_set.c"
      .assign te_smt.deallocation = b
      .// Push deallocation into the block so that it is available at gen time for break/continue/return.
      .assign te_blk.deallocation = te_blk.deallocation + te_smt.deallocation
    .else
      .include "${te_file.arc_path}/t.smt_sr.declare_ref.c"
      .assign te_smt.declaration = b
    .end if
  .end if
  .assign cast = ""
  .assign subtypecheck = ""
  .select any sub_r_rel from instances of R_REL where ( false )
  .if ( "subsuper" == te_lnk.assoc_type )
    .select any sub_r_rel related by te_class->O_OBJ[R2019]->R_OIR[R201]->R_RGO[R203]->R_SUB[R205]->R_SUBSUP[R213]->R_REL[R206] where ( selected.Numb == te_lnk.rel_number )
    .if ( not_empty sub_r_rel )
      .assign cast = ( "(" + te_lnk.te_classGeneratedName ) + " *) "
      .include "${te_file.arc_path}/t.smt_sr.subtypecheck.c"
    .end if
  .end if
  .assign b = ""
  .// single-link chains
  .//  #  | first | last | startmany | multiplicity | linkmult | by_where | example
  .if ( ( te_lnk.first ) and ( te_lnk.last ) )
    .assign te_smt.OAL = te_smt.OAL + te_lnk.OAL
    .if ( not te_select_related.start_many )
      .if ( "one" == te_select_related.multiplicity )
        .if ( 0 == te_lnk.Mult )
          .if ( not_empty sub_r_rel )
            .include "${te_file.arc_path}/t.smt_sr.result_ref_init.c"
            .assign b = b + subtypecheck
          .end if
          .if ( not te_select_related.by_where )
  .//  1  |   T   |  T   |     F     |   "one"      |  0:one   |    F     | select one b related by a->B[R1];
  .include "${te_file.arc_path}/t.smt_sr.oneany_atob1.c"
          .else
  .//  2  |   T   |  T   |     F     |   "one"      |  0:one   |    T     | select one b related by a->B[R1] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.oneany_atob1where.c"
          .end if
        .else
          .if ( not te_select_related.by_where )
  .//  3  |   T   |  T   |     F     | "one"->"any" |  1:many  |    F     | select one b related by a->B[R9];                              // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_atobm.c"
          .else
  .//  4  |   T   |  T   |     F     | "one"->"any" |  1:many  |    T     | select one b related by a->B[R9] where ( selected.i == 7 );    // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_atobmwhere.c"
          .end if
        .end if
      .elif ( "any" == te_select_related.multiplicity )
        .if ( 0 == te_lnk.Mult )
          .if ( not_empty sub_r_rel )
            .include "${te_file.arc_path}/t.smt_sr.result_ref_init.c"
            .assign b = b + subtypecheck
          .end if
          .if ( not te_select_related.by_where )
  .//  5  |   T   |  T   |     F     |   "any"      |  0:one   |    F     | select any b related by a->B[R1];                              // Note 1
  .include "${te_file.arc_path}/t.smt_sr.oneany_atob1.c"
          .else
  .//  6  |   T   |  T   |     F     |   "any"      |  0:one   |    T     | select any b related by a->B[R1] where ( selected.i == 7 );    // Note 1
  .include "${te_file.arc_path}/t.smt_sr.oneany_atob1where.c"
          .end if
        .else
          .if ( not te_select_related.by_where )
  .//  7  |   T   |  T   |     F     |   "any"      |  1:many  |    F     | select any b related by a->B[R9];
  .include "${te_file.arc_path}/t.smt_sr.oneany_atobm.c"
          .else
  .//  8  |   T   |  T   |     F     |   "any"      |  1:many  |    T     | select any b related by a->B[R9] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.oneany_atobmwhere.c"
          .end if
        .end if
      .else
        .if ( 0 == te_lnk.Mult )
          .if ( not te_select_related.by_where )
  .//  9  |   T   |  T   |     F     |   "many"     |  0:one   |    F     | select many bs related by a->B[R1];                            // Note 1
  .include "${te_file.arc_path}/t.smt_sr.many_atob1.c"
          .else
  .// 10  |   T   |  T   |     F     |   "many"     |  0:one   |    T     | select many bs related by a->B[R1] where ( selected.i == 7 );  // Note 1
  .include "${te_file.arc_path}/t.smt_sr.many_atob1where.c"
          .end if
        .else
          .if ( not te_select_related.by_where )
  .// 11  |   T   |  T   |     F     |   "many"     |  1:many  |    F     | select many bs related by a->B[R9];
  .include "${te_file.arc_path}/t.smt_sr.many_atobm.c"
          .else
  .// 12  |   T   |  T   |     F     |   "many"     |  1:many  |    T     | select many bs related by a->B[R9] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.many_atobmwhere.c"
          .end if
        .end if
      .end if
    .else
      .if ( "one" == te_select_related.multiplicity )
        .if ( 0 == te_lnk.Mult )
          .if ( not te_select_related.by_where )
  .// 13  |   T   |  T   |     T     | "one"->"any" |  0:one   |    F     | select one b related by as->B[R1];                             // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_astob1.c"
          .else
  .// 14  |   T   |  T   |     T     | "one"->"any" |  0:one   |    T     | select one b related by as->B[R1] where ( selected.i == 7 );   // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_astob1where.c"
          .end if
        .else
          .if ( not te_select_related.by_where )
  .// 15  |   T   |  T   |     T     | "one"->"any" |  1:many  |    F     | select one b related by as->B[R9];                             // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_astobm.c"
          .else
  .// 16  |   T   |  T   |     T     | "one"->"any" |  1:many  |    T     | select one b related by as->B[R9] where ( selected.i == 7 );   // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_astobmwhere.c"
          .end if
        .end if
      .elif ( "any" == te_select_related.multiplicity )
        .if ( 0 == te_lnk.Mult )
          .if ( not te_select_related.by_where )
  .// 17  |   T   |  T   |     T     |   "any"      |  0:one   |    F     | select any b related by as->B[R1];
  .include "${te_file.arc_path}/t.smt_sr.oneany_astob1.c"
          .else
  .// 18  |   T   |  T   |     T     |   "any"      |  0:one   |    T     | select any b related by as->B[R1] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.oneany_astob1where.c"
          .end if
        .else
          .if ( not te_select_related.by_where )
  .// 19  |   T   |  T   |     T     |   "any"      |  1:many  |    F     | select any b related by as->B[R9];
  .include "${te_file.arc_path}/t.smt_sr.oneany_astobm.c"
          .else
  .// 20  |   T   |  T   |     T     |   "any"      |  1:many  |    T     | select any b related by as->B[R9] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.oneany_astobmwhere.c"
          .end if
        .end if
      .else
        .if ( 0 == te_lnk.Mult )
          .if ( not te_select_related.by_where )
  .// 21  |   T   |  T   |     T     |   "many"     |  0:one   |    F     | select many bs related by as->B[R1];
  .include "${te_file.arc_path}/t.smt_sr.many_astob1.c"
          .else
  .// 22  |   T   |  T   |     T     |   "many"     |  0:one   |    T     | select many bs related by as->B[R1] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.many_astob1where.c"
          .end if
        .else
          .if ( not te_select_related.by_where )
  .// 23  |   T   |  T   |     T     |   "many"     |  1:many  |    F     | select many bs related by as->B[R9];
  .include "${te_file.arc_path}/t.smt_sr.many_astobm.c"
          .else
  .// 24  |   T   |  T   |     T     |   "many"     |  1:many  |    T     | select many bs related by as->B[R9] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.many_astobmwhere.c"
          .end if .// by_where
        .end if .// last link mult
      .end if .// one, any, many
    .end if .// start many
  .else
  .//
  .// multi-link chains
    .// multi-link chains
    .// This may need to be refactored to remove some degree of control.
    .assign depth = 0
    .if ( "many" == te_select_related.multiplicity )
      .include "${te_file.arc_path}/t.smt_sr.result_set_init.c"
    .else
      .include "${te_file.arc_path}/t.smt_sr.result_ref_init.c"
    .end if
    .assign b = b + "${ws}{"
    .assign depth = depth + 1
    .if ( te_select_related.start_many )
      .assign depth = depth + 1
      .include "${te_file.arc_path}/t.smt_sr.start_many.c"
    .else
      .assign depth = depth + 1
      .include "${te_file.arc_path}/t.smt_sr.start_one.c"
    .end if
    .// drill through the chained links
    .while ( not te_lnk.last )
      .assign depth = depth + 1
      .assign te_smt.OAL = te_smt.OAL + te_lnk.OAL
      .if ( 0 == te_lnk.Mult )
        .assign cast = ""
        .if ( "subsuper" == te_lnk.assoc_type )
          .// CDS This is a 50 percent guess.  We need to know sub->super or super->sub.
          .// CDS Need to do subtype checks while drilling.
          .assign cast = ( "(" + te_lnk.te_classGeneratedName ) + " *) "
        .end if
        .include "${te_file.arc_path}/t.smt_sr.chainto1.c"
      .else
        .include "${te_file.arc_path}/t.smt_sr.chaintom.c"
      .end if
      .select one te_lnk related by te_lnk->TE_LNK[R2075.'succeeds']
    .end while
    .assign te_smt.OAL = te_smt.OAL + te_lnk.OAL
    .assign cast = ""
    .assign subtypecheck = ""
    .if ( "subsuper" == te_lnk.assoc_type )
      .select any sub_r_rel related by te_class->O_OBJ[R2019]->R_OIR[R201]->R_RGO[R203]->R_SUB[R205]->R_SUBSUP[R213]->R_REL[R206] where ( selected.Numb == te_lnk.rel_number )
      .if ( not_empty sub_r_rel )
        .assign cast = ( "(" + te_lnk.te_classGeneratedName ) + " *) "
        .include "${te_file.arc_path}/t.smt_sr.subtypecheck.c"
      .end if
    .end if
    .// now finish up
    .if ( "one" == te_select_related.multiplicity )
      .if ( 0 == te_lnk.Mult )
        .if ( not_empty sub_r_rel )
          .assign b = b + subtypecheck
        .end if
        .if ( not te_select_related.by_where )
  .//  1m |   T   |  F   |   "one"      |  0:one   |    F     | select one c related by a(s)->B[R1]->C[R2];
  .include "${te_file.arc_path}/t.smt_sr.multi_oneany_astob1.c"
        .else
  .//  2m |   T   |  F   |   "one"      |  0:one   |    T     | select one c related by a(s)->B[R1]->C[R2] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.multi_oneany_astob1where.c"
        .end if
      .else
        .if ( not te_select_related.by_where )
  .//  3m |   T   |  F   | "one"->"any" |  1:many  |    F     | select one c related by a(s)->B[R9]->C[R8];                              // Note 2
  .include "${te_file.arc_path}/t.smt_sr.oneany_atobm.c"
        .else
  .//  4m |   T   |  F   | "one"->"any" |  1:many  |    T     | select one c related by a(s)->B[R9]->C[R8] where ( selected.i == 7 );    // Note 2
  .include "${te_file.arc_path}/t.smt_sr.multi_oneany_astobmwhere.c"
        .end if
      .end if
    .elif ( "any" == te_select_related.multiplicity )
      .if ( 0 == te_lnk.Mult )
        .if ( not_empty sub_r_rel )
          .assign b = b + subtypecheck
        .end if
        .if ( not te_select_related.by_where )
  .//  5m |   T   |  F   |   "any"      |  0:one   |    F     | select any c related by a(s)->B[R1]->C[R2];                              // Note 1, 2
  .include "${te_file.arc_path}/t.smt_sr.multi_oneany_astob1.c"
        .else
  .//  6m |   T   |  F   |   "any"      |  0:one   |    T     | select any c related by a(s)->B[R1]->C[R2] where ( selected.i == 7 );    // Note 1, 2
  .include "${te_file.arc_path}/t.smt_sr.multi_oneany_astob1where.c"
        .end if
      .else
        .if ( not te_select_related.by_where )
  .//  7m |   T   |  F   |   "any"      |  1:many  |    F     | select any c related by a(s)->B[R9]->C[R8];
  .include "${te_file.arc_path}/t.smt_sr.oneany_atobm.c"
        .else
  .//  8m |   T   |  F   |   "any"      |  1:many  |    T     | select any c related by a(s)->B[R9]->C[R8] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.multi_oneany_astobmwhere.c"
        .end if
      .end if
    .else
      .if ( 0 == te_lnk.Mult )
        .if ( not_empty sub_r_rel )
          .assign b = b + subtypecheck
        .end if
        .if ( not te_select_related.by_where )
  .//  9m |   T   |  F   |   "many"     |  0:one   |    F     | select many cs related by a(s)->B[R1]->C[R2];                            // Note 1
  .include "${te_file.arc_path}/t.smt_sr.multi_many_astob1.c"
        .else
  .// 10m |   T   |  F   |   "many"     |  0:one   |    T     | select many cs related by a(s)->B[R1]->C[R2] where ( selected.i == 7 );  // Note 1
  .include "${te_file.arc_path}/t.smt_sr.multi_many_astob1where.c"
        .end if
      .else
        .if ( not te_select_related.by_where )
  .// 11m |   T   |  F   |   "many"     |  1:many  |    F     | select many cs related by a(s)->B[R9]->C[R8];
  .include "${te_file.arc_path}/t.smt_sr.multi_many_astobm.c"
        .else
  .// 12m |   T   |  F   |   "many"     |  1:many  |    T     | select many cs related by a(s)->B[R9]->C[R8] where ( selected.i == 7 );
  .include "${te_file.arc_path}/t.smt_sr.multi_many_astobmwhere.c"
        .end if .// by_where
      .end if .// last link mult
    .end if .// one, any, many
    .//
    .while ( depth > 0 )
      .assign b = b + "}"
      .assign depth = depth - 1
    .end while
    .assign b = b + "\n"
  .end if
  .assign te_smt.buffer = b
  .if ( te_select_related.by_where )
    .assign te_smt.OAL = te_smt.OAL + " WHERE ( ${te_select_related.where_clause_OAL} )"
  .end if
  .end if
.end function
.//
