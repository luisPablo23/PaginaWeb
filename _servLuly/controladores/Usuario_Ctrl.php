<?php
//gen 11/11/2020 18:15:01 dst
class Usuario_Ctrl
{
    public $M_Usuariologueado = null;
    public function __construct()
    {
        $this->M_Usuariologueado = new M_Usuariologueado();
    }

    public function selUsuario($f3)
    {
        $idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
        $llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
        if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave, 'selUsuario',$f3)) {
            //if ($this->M_Usuariologueado->ValidaSession('700000001', '$1$GL5.XO3.$QiSWFBUFUrV7Be2JuX9O01')) {
            $pCampo0 = is_null($f3->get('POST.pCampo0')) ? 'T' : $f3->get('POST.pCampo0');
            $pValor0 = is_null($f3->get('POST.pValor0')) ? '' : $f3->get('POST.pValor0');
            $pCampo1 = is_null($f3->get('POST.pCampo1')) ? 'T' : $f3->get('POST.pCampo1');
            $pValor1 = is_null($f3->get('POST.pValor1')) ? '' : $f3->get('POST.pValor1');
            $pCampo2 = is_null($f3->get('POST.pCampo2')) ? 'T' : $f3->get('POST.pCampo2');
            $pValor2 = is_null($f3->get('POST.pValor2')) ? '' : $f3->get('POST.pValor2');
            $pCampo3 = is_null($f3->get('POST.pCampo3')) ? 'T' : $f3->get('POST.pCampo3');
            $pValor3 = is_null($f3->get('POST.pValor3')) ? '' : $f3->get('POST.pValor3');
            $pCampo4 = is_null($f3->get('POST.pCampo4')) ? 'T' : $f3->get('POST.pCampo4');
            $pValor4 = is_null($f3->get('POST.pValor4')) ? '' : $f3->get('POST.pValor4');
            $pCampo5 = is_null($f3->get('POST.pCampo5')) ? 'T' : $f3->get('POST.pCampo5');
            $pValor5 = is_null($f3->get('POST.pValor5')) ? '' : $f3->get('POST.pValor5');
            $pCampo6 = is_null($f3->get('POST.pCampo6')) ? 'T' : $f3->get('POST.pCampo6');
            $pValor6 = is_null($f3->get('POST.pValor6')) ? '' : $f3->get('POST.pValor6');
            $pCampo7 = is_null($f3->get('POST.pCampo7')) ? 'T' : $f3->get('POST.pCampo7');
            $pValor7 = is_null($f3->get('POST.pValor7')) ? '' : $f3->get('POST.pValor7');
            $oDav_Ctrol = new _Dav_Ctrol();
            $Con = $oDav_Ctrol->fnDevuelveConsulta('visusuario', $pCampo0, $pValor0, $pCampo1, $pValor1, $pCampo2, $pValor2, $pCampo3, $pValor3, $pCampo4, $pValor4, $pCampo5, $pValor5, $pCampo6, $pValor6, $pCampo7, $pValor7);
            $sql = $Con;
            try {
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'Lista de Usuarios';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'Usuario seleccionadas';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
            }
        } else {
            $msg = 'llave no valida';
            $items = '';
            echo json_encode([
                'mesaje' => $msg,
                'info' => [
                    'item' => $items
                ]
            ]);
        }
    }

    public function addUsuario($f3)
    {
        $idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
        $llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
        if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave, 'addUsuario',$f3)) {
            $Tipo = 'C';
            $idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
            $idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
            $nombreusuario = is_null($f3->get('POST.pnombreusuario')) ? 'T' : $f3->get('POST.pnombreusuario');
            $clave = is_null($f3->get('POST.pclave')) ? 'T' : $f3->get('POST.pclave');
            $salt = is_null($f3->get('POST.psalt')) ? 'T' : $f3->get('POST.psalt');
            $pin = is_null($f3->get('POST.ppin')) ? 'T' : $f3->get('POST.ppin');
            $idestadousuario = is_null($f3->get('POST.pidestadousuario')) ? 'T' : $f3->get('POST.pidestadousuario');
            $idtipousuario = is_null($f3->get('POST.pidtipousuario')) ? 'T' : $f3->get('POST.pidtipousuario');
            $estilo = is_null($f3->get('POST.pestilo')) ? 'T' : $f3->get('POST.pestilo');
            $idcorporacion = is_null($f3->get('POST.pidcorporacion')) ? 'T' : $f3->get('POST.pidcorporacion');
            $idempresa = is_null($f3->get('POST.pidempresa')) ? 'T' : $f3->get('POST.pidempresa');
            $idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
            $sql = "CALL pcruUsuario('" . $Tipo . "','" . $idusuario . "','" . $idpersona . "','" . $nombreusuario . "','" . $clave . "','" . $salt . "','" . $pin . "','" . $idestadousuario . "','" . $idtipousuario . "','" . $estilo . "','" . $idcorporacion . "','" . $idempresa . "','" . $idsucursal . "'); ";
            try {
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'add Usuario';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'Usuario registrada';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
            }
        } else {
            $msg = 'llave no valida';
            $items = '';
            echo json_encode([
                'mesaje' => $msg,
                'info' => [
                    'item' => $items
                ]
            ]);
        }
    }

    public function getUsuario($f3)
    {
        $idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
        $llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
        if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave, 'getUsuario',$f3)) {
            $Tipo = 'R';
            $idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
            $idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
            $nombreusuario = is_null($f3->get('POST.pnombreusuario')) ? 'T' : $f3->get('POST.pnombreusuario');
            $clave = is_null($f3->get('POST.pclave')) ? 'T' : $f3->get('POST.pclave');
            $salt = is_null($f3->get('POST.psalt')) ? 'T' : $f3->get('POST.psalt');
            $pin = is_null($f3->get('POST.ppin')) ? 'T' : $f3->get('POST.ppin');
            $idestadousuario = is_null($f3->get('POST.pidestadousuario')) ? 'T' : $f3->get('POST.pidestadousuario');
            $idtipousuario = is_null($f3->get('POST.pidtipousuario')) ? 'T' : $f3->get('POST.pidtipousuario');
            $estilo = is_null($f3->get('POST.pestilo')) ? 'T' : $f3->get('POST.pestilo');
            $idcorporacion = is_null($f3->get('POST.pidcorporacion')) ? 'T' : $f3->get('POST.pidcorporacion');
            $idempresa = is_null($f3->get('POST.pidempresa')) ? 'T' : $f3->get('POST.pidempresa');
            $idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
            $sql = "CALL pcruUsuario('" . $Tipo . "','" . $idusuario . "','" . $idpersona . "','" . $nombreusuario . "','" . $clave . "','" . $salt . "','" . $pin . "','" . $idestadousuario . "','" . $idtipousuario . "','" . $estilo . "','" . $idcorporacion . "','" . $idempresa . "','" . $idsucursal . "'); ";
            try {
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'getUsuario';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'Usuario encontrada';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
            }
        } else {
            $msg = 'llave no valida';
            $items = '';
            echo json_encode([
                'mesaje' => $msg,
                'info' => [
                    'item' => $items
                ]
            ]);
        }
    }

    public function updUsuario($f3)
    {
        $idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
        $llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
        if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave, 'updUsuario',$f3)) {
            $Tipo = 'U';
            $idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
            $idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
            $nombreusuario = is_null($f3->get('POST.pnombreusuario')) ? 'T' : $f3->get('POST.pnombreusuario');
            $clave = is_null($f3->get('POST.pclave')) ? 'T' : $f3->get('POST.pclave');
            $salt = is_null($f3->get('POST.psalt')) ? 'T' : $f3->get('POST.psalt');
            $pin = is_null($f3->get('POST.ppin')) ? 'T' : $f3->get('POST.ppin');
            $idestadousuario = is_null($f3->get('POST.pidestadousuario')) ? 'T' : $f3->get('POST.pidestadousuario');
            $idtipousuario = is_null($f3->get('POST.pidtipousuario')) ? 'T' : $f3->get('POST.pidtipousuario');
            $estilo = is_null($f3->get('POST.pestilo')) ? 'T' : $f3->get('POST.pestilo');
            $idcorporacion = is_null($f3->get('POST.pidcorporacion')) ? 'T' : $f3->get('POST.pidcorporacion');
            $idempresa = is_null($f3->get('POST.pidempresa')) ? 'T' : $f3->get('POST.pidempresa');
            $idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
            $sql = "CALL pcruUsuario('" . $Tipo . "','" . $idusuario . "','" . $idpersona . "','" . $nombreusuario . "','" . $clave . "','" . $salt . "','" . $pin . "','" . $idestadousuario . "','" . $idtipousuario . "','" . $estilo . "','" . $idcorporacion . "','" . $idempresa . "','" . $idsucursal . "'); ";
            try {
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'update Usuario';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
                $resulto = $f3->get('DB')->exec($sql);
                $items = array();
                $msg = 'Usuario encontrada';
                $items = $resulto;
                echo json_encode([
                    'mesaje' => $msg,
                    'info' => [
                        'item' => $items
                    ]
                ]);
            } catch (PDOException $e) {
                echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
            }
        } else {
            $msg = 'llave no valida';
            $items = '';
            echo json_encode([
                'mesaje' => $msg,
                'info' => [
                    'item' => $items
                ]
            ]);
        }
    }
}
