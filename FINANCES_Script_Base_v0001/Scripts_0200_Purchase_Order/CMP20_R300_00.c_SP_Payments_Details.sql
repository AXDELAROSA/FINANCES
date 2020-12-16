-- //////////////////////////////////////////////////////////////
-- // DATA BASE:		COMPRAS
-- // MODULE:			PAYMENTS_DETAILS
-- // OPERATION:		SP'S
-- //////////////////////////////////////////////////////////////
-- // AUTHOR:			AX DE LA ROSA			
-- // CREATION DATE:	20200916
-- ////////////////////////////////////////////////////////////// 

-- USE [COMPRAS]
GO

-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / EL DETALLE DE LOS PAGOS REALIZADOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_DETAILS_PAYMENT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_DETAILS_PAYMENT]
GO
--		 EXECUTE [dbo].[PG_LI_DETAILS_PAYMENT] 0,139,21
CREATE PROCEDURE [dbo].[PG_LI_DETAILS_PAYMENT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	-- =========================================		
	IF @VP_MENSAJE=''
	BEGIN
		SELECT		
					F_DETAILS_PAYMENT
					,D_PAYMENT_METHOD
					,NO_FACTURA_PAGADA		
					,NO_IDENTICACION_PAGO
					,NO_CUENTA_ORIGEN					
					,NO_CUENTA_DESTINO				
					--,PAGO_IMPORTE
					,PAGO_REALIZADO		
					--,PAGO_RESTANTE			
					,C_DETAILS_PAYMENT
					,DETAILS_PAYMENT.K_PAYMENT_METHOD
					,K_DETAILS_PAYMENT
					,DETAILS_PAYMENT.K_PAYMENT
					,K_HEADER_PURCHASE_ORDER
					-- =============================	
		FROM		PAYMENT
		INNER JOIN	DETAILS_PAYMENT		ON	DETAILS_PAYMENT.K_PAYMENT=PAYMENT.K_PAYMENT
		INNER JOIN	BD_GENERAL.DBO.PAYMENT_METHOD	ON	DETAILS_PAYMENT.K_PAYMENT_METHOD=PAYMENT_METHOD.K_PAYMENT_METHOD
		WHERE		K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		--AND			K_STATUS_PAYMENT=1
		ORDER BY	F_DETAILS_PAYMENT, K_PAYMENT DESC
	END	
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / LOS PAGOS PENDIENTES POR APLICAR
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_LI_PAYMENT_X_APLICAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_LI_PAYMENT_X_APLICAR]
GO
--		 EXECUTE [dbo].[PG_LI_PAYMENT_X_APLICAR] 0,139,21
CREATE PROCEDURE [dbo].[PG_LI_PAYMENT_X_APLICAR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	-- =========================================
	IF @VP_MENSAJE=''
	BEGIN
			
		SELECT		
					F_DETAILS_PAYMENT
					,D_PAYMENT_METHOD
					,NO_FACTURA_PAGADA		
					,NO_IDENTICACION_PAGO
					,NO_CUENTA_ORIGEN					
					,NO_CUENTA_DESTINO				
					--,PAGO_IMPORTE
					--,PAGO_REALIZADO		
					,PAGO_X_APLICAR
					--,PAGO_RESTANTE			
					,C_DETAILS_PAYMENT
					,DETAILS_PAYMENT.K_PAYMENT_METHOD
					,K_DETAILS_PAYMENT
					,DETAILS_PAYMENT.K_PAYMENT
					,K_HEADER_PURCHASE_ORDER
					-- =============================	
		FROM		PAYMENT
		INNER JOIN	DETAILS_PAYMENT		ON	DETAILS_PAYMENT.K_PAYMENT=PAYMENT.K_PAYMENT
		INNER JOIN	BD_GENERAL.DBO.PAYMENT_METHOD	ON	DETAILS_PAYMENT.K_PAYMENT_METHOD=PAYMENT_METHOD.K_PAYMENT_METHOD
		--WHERE		K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		WHERE		K_VENDOR=	(
								SELECT	K_VENDOR
								FROM	HEADER_PURCHASE_ORDER
								WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER		)
		AND			K_STATUS_PAYMENT=0
		AND			DETAILS_PAYMENT.K_HEADER_PURCHASE_ORDER=-999
		ORDER BY	F_DETAILS_PAYMENT, K_PAYMENT DESC
	END	
	-- /////////////////////////////////////////////////////////////////////
GO



-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / EL DETALLE DE LOS PAGOS REALIZADOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_DETAILS_PAYMENT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_DETAILS_PAYMENT]
GO
--		 EXECUTE [dbo].[PG_SK_DETAILS_PAYMENT] 0,139,-999,11
CREATE PROCEDURE [dbo].[PG_SK_DETAILS_PAYMENT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_HEADER_PURCHASE_ORDER		INT,
	@PP_K_DETAILS_PAYMENT			INT
AS
	DECLARE @VP_MENSAJE				VARCHAR(300) = ''
	-- =========================================		
	IF @VP_MENSAJE=''
	BEGIN
		SELECT		TOP (1)
					F_DETAILS_PAYMENT
					,D_PAYMENT_METHOD
					,NO_FACTURA_PAGADA		
					,NO_IDENTICACION_PAGO
					,NO_CUENTA_ORIGEN					
					,NO_CUENTA_DESTINO				
					--,PAGO_IMPORTE
					--,PAGO_REALIZADO		
					,FORMAT(PAGO_X_APLICAR, 'N', 'en-us') AS PAGO_X_APLICAR
					--,PAGO_RESTANTE			
					--,TOTAL_PURCHASE_ORDER
					,C_DETAILS_PAYMENT
					,DETAILS_PAYMENT.K_PAYMENT_METHOD
					,K_DETAILS_PAYMENT
					,DETAILS_PAYMENT.K_PAYMENT
					,DETAILS_PAYMENT.K_HEADER_PURCHASE_ORDER
					-- =============================	
		FROM		PAYMENT
		INNER JOIN	DETAILS_PAYMENT		ON	DETAILS_PAYMENT.K_PAYMENT=PAYMENT.K_PAYMENT
		INNER JOIN	BD_GENERAL.DBO.PAYMENT_METHOD	ON	DETAILS_PAYMENT.K_PAYMENT_METHOD=PAYMENT_METHOD.K_PAYMENT_METHOD
		--INNER JOIN	HEADER_PURCHASE_ORDER	ON	DETAILS_PAYMENT.K_HEADER_PURCHASE_ORDER=HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER
		WHERE		DETAILS_PAYMENT.K_HEADER_PURCHASE_ORDER=@PP_HEADER_PURCHASE_ORDER
		AND			K_DETAILS_PAYMENT=@PP_K_DETAILS_PAYMENT
		AND			K_STATUS_PAYMENT=0
	END	
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / EL DETALLE DE LOS PAGOS REALIZADOS
-- //						SE UTILIZA PARA CARGAR LOS VALORES INICIALES
-- //						AL MOMENTO DE ESTABLECER LOS PAGOS.
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_SK_TOTAL_A_PAGAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_SK_TOTAL_A_PAGAR]
GO
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,16		-- BLANKET
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,15		-- COMPLETA
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,21		-- PARCIAL
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,194		-- CERRADA
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,13		-- CERRADA
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,307		-- CERRADA
--		 EXECUTE [dbo].[PG_SK_TOTAL_A_PAGAR] 0,139,298		-- CERRADA
CREATE PROCEDURE [dbo].[PG_SK_TOTAL_A_PAGAR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
			SELECT	TOP (1)
			FORMAT(
					(CASE
						WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	TOTAL_PURCHASE_ORDER_CLOSED
						ELSE	TOTAL_PURCHASE_ORDER
					END)
			, 'N', 'en-us')	
			AS TOTAL_PURCHASE_ORDER,
			-- =======================================================================================================================================
			-- =======================================================================================================================================
			FORMAT(		
					(CASE
						WHEN
							(SELECT	COUNT(K_HEADER_PURCHASE_ORDER)	
							FROM	DETAILS_PAYMENT	
							WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER)=0 AND	K_STATUS_PURCHASE_ORDER=14 THEN	0
						WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	(TOTAL_PURCHASE_ORDER_CLOSED-PREPAID_PURCHASE_ORDER)
						ELSE	(TOTAL_PURCHASE_ORDER-PREPAID_PURCHASE_ORDER)
					END) 
			, 'N', 'en-us') 
			AS PAGO_IMPORTE,
			-- =======================================================================================================================================
			-- =======================================================================================================================================
					(CASE
						WHEN
							(SELECT	COUNT(K_HEADER_PURCHASE_ORDER)	
							FROM	DETAILS_PAYMENT	
							WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER)=0 AND	K_STATUS_PURCHASE_ORDER=14 THEN	'SE DEBE INDICAR LA CANTIDAD A PAGAR DE MANERA MANUAL, AL SER UNA ORDEN CERRADA PARCIALMENTE'
						ELSE	''
					END)	AS MENSAJE,
			-- =======================================================================================================================================
			-- =======================================================================================================================================
					ISNULL((
					SELECT	TOP (1)
							NO_CUENTA_ORIGEN
					FROM	DETAILS_PAYMENT, PAYMENT
					WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER--K_HEADER_PURCHASE_ORDER
					AND		PAYMENT.K_PAYMENT=DETAILS_PAYMENT.K_PAYMENT
					),'')	AS	NO_CUENTA_ORIGEN,
			-- =======================================================================================================================================
			-- =======================================================================================================================================
					ISNULL((
					SELECT	TOP (1)
							ISNULL(NO_CUENTA_DESTINO,'')
					FROM	DETAILS_PAYMENT, PAYMENT
					WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER--K_HEADER_PURCHASE_ORDER
					AND		PAYMENT.K_PAYMENT=DETAILS_PAYMENT.K_PAYMENT
					),'')	AS	NO_CUENTA_DESTINO,
			-- =======================================================================================================================================
			-- =======================================================================================================================================
					ISNULL((
					SELECT	TOP (1)
							ISNULL(K_PAYMENT_METHOD,-1)
					FROM	DETAILS_PAYMENT, PAYMENT
					WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER--K_HEADER_PURCHASE_ORDER
					AND		PAYMENT.K_PAYMENT=DETAILS_PAYMENT.K_PAYMENT
					),-1)	AS	K_PAYMENT_METHOD,
			-- =======================================================================================================================================
			-- =======================================================================================================================================
					K_CURRENCY
		FROM		HEADER_PURCHASE_ORDER
		WHERE		HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERTA LOS PAGOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_PAYMENT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_PAYMENT]
GO
CREATE PROCEDURE [dbo].[PG_IN_PAYMENT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	-----=====================================================
	@PP_F_PAYMENT					[DATE],
	@PP_NO_CUENTA_ORIGEN			[VARCHAR](100),
	@PP_PAGO_REALIZADO				[DECIMAL](19,4),
	-----=====================================================
	@PP_OUTPUT_K_PAYMENT			INT		OUTPUT
AS			
DECLARE @VP_MENSAJE					VARCHAR(500) = ''
DECLARE @VP_K_PAYMENT				INT = 0
DECLARE @VP_K_VENDOR				INT
		-- /////////////////////////////////////////////////////////////////////
	DECLARE @VP_BD_NAME				VARCHAR(300) = ''
		IF	@PP_K_SISTEMA_EXE=0
			SET @VP_BD_NAME='COMPRAS_Pruebas'
		ELSE
			SET @VP_BD_NAME='COMPRAS'

		EXECUTE [BD_GENERAL].dbo.[PG_SK_CATALOGO_K_MAX_GET]		@PP_K_SISTEMA_EXE, @VP_BD_NAME,
																'PAYMENT', 'K_PAYMENT',
																@OU_K_TABLA_DISPONIBLE = @VP_K_PAYMENT	OUTPUT
	
	IF @VP_MENSAJE=''
	BEGIN
		SELECT	@VP_K_VENDOR=K_VENDOR
		FROM	HEADER_PURCHASE_ORDER
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		
		IF (@VP_K_VENDOR IS NULL) OR @VP_K_VENDOR<=0
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
			SET @VP_MENSAJE='Proveedor no Encontrado. [VENDOR#'+CONVERT(VARCHAR(10),@VP_K_VENDOR)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END
	END

	IF @VP_MENSAJE=''
	BEGIN
	--============================================================================
	--======================================INSERTAR PAYMENT
	--============================================================================
		INSERT INTO PAYMENT
			(	[K_PAYMENT]				
				-- ============================
				,[K_STATUS_PAYMENT]		
				,[K_VENDOR]				
				-- ============================
				,[F_PAYMENT]
				,[NO_CUENTA_ORIGEN]				
				,[PAGO_IMPORTE]
				,[PAGO_APLICADO]			
				,[PAGO_X_APLICAR]						
				-- ============================
				,[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
				[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
		VALUES	
			(	@VP_K_PAYMENT
				-- ============================
				,1
				,@VP_K_VENDOR
				-- ============================
				,@PP_F_PAYMENT
				,@PP_NO_CUENTA_ORIGEN
				,@PP_PAGO_REALIZADO
				,@PP_PAGO_REALIZADO						
				,0
				-- ============================
				,@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
				0, NULL, NULL  )

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='El pago no fue ingresado. [PAGO#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END
		SET @PP_OUTPUT_K_PAYMENT = @VP_K_PAYMENT
	END
-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> INSERTA LOS DETALLES DE LOS PAGOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_DETAILS_PAYMENT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_DETAILS_PAYMENT]
GO
--		 EXECUTE [dbo].[PG_IN_DETAILS_PAYMENT] 0,139,21,'',1,'2020/09/17','','121A21S1A','','',1500,1000,950
CREATE PROCEDURE [dbo].[PG_IN_DETAILS_PAYMENT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_C_DETAILS_PAYMENT			[VARCHAR](500),
	-----=====================================================
	@PP_K_PAYMENT_METHOD			[INT],
	@PP_F_PAYMENT					[DATE],
	@PP_NO_IDENTICACION_PAGO		[VARCHAR](100),
	@PP_NO_FACTURA_PAGADA			[VARCHAR](100),
	@PP_NO_CUENTA_ORIGEN			[VARCHAR](100),
	@PP_NO_CUENTA_DESTINO			[VARCHAR](100),
	@PP_PAGO_REALIZADO				[DECIMAL](19,4),	
	@PP_UPDATE_CLOSED				[DECIMAL](19,4),
	-----=====================================================
	-----=====================================================
	@PP_K_PAGO_DIFERENTE_MONEDA		[INT],
	@PP_K_PAYMENT_CURRENCY			[INT],
	@PP_TIPO_CAMBIO					[VARCHAR](100),	--[DECIMAL](19,4),
	@PP_PAGO_REALIZADO_CONVERTIDO	[VARCHAR](100)	--[DECIMAL](19,4)
AS			
DECLARE @VP_MENSAJE						VARCHAR(500) = ''
	, @VP_TOTAL_A_PAGAR				INT
	, @VP_K_PAYMENT					INT
	, @VP_K_ESTATUS					INT
	, @VP_TIPO_CAMBIO					DECIMAL(10,4)
	, @VP_PAGO_REALIZADO_CONVERTIDO		DECIMAL(10,4)
BEGIN TRANSACTION 
BEGIN TRY
		-- /////////////////////////////////////////////////////////////////////
--	IF @VP_MENSAJE=''
--	BEGIN		
--		SELECT *
--		FROM	HEADER_PURCHASE_ORDER
--		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
--	END
--	0,139,  298 , '2DO PAGO' , 3 , '2020/12/10' , '' , 'J33' , '4014494140' , '002164700901931454' , 39204 , -1 , 0 , 1 , '' , '' 
--	IF @VP_MENSAJE=''
--	BEGIN		

	SELECT @VP_TIPO_CAMBIO					=	CAST( @PP_TIPO_CAMBIO				AS DECIMAL(19,4))
	SELECT @VP_PAGO_REALIZADO_CONVERTIDO	=	CAST( @PP_PAGO_REALIZADO_CONVERTIDO	AS DECIMAL(19,4))

	SELECT
		@VP_TOTAL_A_PAGAR=	((CASE
								WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	TOTAL_PURCHASE_ORDER_CLOSED
								ELSE	TOTAL_PURCHASE_ORDER
							END))-PREPAID_PURCHASE_ORDER
	FROM		HEADER_PURCHASE_ORDER
	WHERE		HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
			
	IF @VP_TOTAL_A_PAGAR=0
	BEGIN
		SET @VP_MENSAJE='LA [PO] NO PRESENTA ADEUDOS'
		RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
	END
	ELSE IF @VP_TOTAL_A_PAGAR<0
	BEGIN
		SET @VP_MENSAJE='LA [PO] TIENE SALDO NEGATIVO, VERIFICAR.'
		RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
	END
--	END

--	IF @VP_MENSAJE=''
--	BEGIN
	EXECUTE [dbo].[PG_IN_PAYMENT]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
									-- ===========================
									@PP_K_HEADER_PURCHASE_ORDER,
									-----=======================
									@PP_F_PAYMENT,					@PP_NO_CUENTA_ORIGEN,
									@PP_PAGO_REALIZADO,
									-----=======================
									@PP_OUTPUT_K_PAYMENT	= 		@VP_K_PAYMENT  OUTPUT
--	END
	
--	IF @VP_MENSAJE=''
--	BEGIN
	--============================================================================
	--======================================INSERTAR DETAILS_PAYMENT
	--============================================================================
	INSERT INTO DETAILS_PAYMENT
		(	[K_HEADER_PURCHASE_ORDER]		
			,[K_PAYMENT]			
			,[C_DETAILS_PAYMENT]				
			-- ============================
			-- CAMPOS ADICIONALES PARA PAYMENTS
			,[K_PAYMENT_METHOD]	
			,[F_DETAILS_PAYMENT]	
			,[NO_IDENTICACION_PAGO]
			,[NO_FACTURA_PAGADA]
			,[NO_CUENTA_DESTINO]	
			--,[PAGO_IMPORTE]		
			,[PAGO_REALIZADO]
			--,[PAGO_RESTANTE]		
			--,[TOTAL_ORDEN_COMPRA]
			-- ============================
			,[K_PAGO_DIFERENTE_MONEDA]
			,[K_PAYMENT_CURRENCY]
			,[TIPO_CAMBIO]
			,[PAGO_REALIZADO_CONVERTIDO]
			-- ============================
			,[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
			[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
	VALUES	
		(	@PP_K_HEADER_PURCHASE_ORDER
			,@VP_K_PAYMENT	
			,@PP_C_DETAILS_PAYMENT
			-- ============================
			,@PP_K_PAYMENT_METHOD		
			,@PP_F_PAYMENT				
			,@PP_NO_IDENTICACION_PAGO	
			,@PP_NO_FACTURA_PAGADA		
			,@PP_NO_CUENTA_DESTINO		
			--,@PP_PAGO_IMPORTE			
			,@PP_PAGO_REALIZADO
			--,@PP_PAGO_RESTANTE			
			--,@PP_TOTAL_ORDEN_COMPRA
			-- ============================
			,@PP_K_PAGO_DIFERENTE_MONEDA
			,@PP_K_PAYMENT_CURRENCY
			,@VP_TIPO_CAMBIO
			,@VP_PAGO_REALIZADO_CONVERTIDO
			-- ============================
			,@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
			0, NULL, NULL  )

		IF @@ROWCOUNT = 0
			BEGIN
				--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				SET @VP_MENSAJE='El detalle del pago no fue ingresado. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
			END				
--	END

--	IF @VP_MENSAJE=''
--	BEGIN

	IF @PP_UPDATE_CLOSED>0
	BEGIN
		UPDATE	HEADER_PURCHASE_ORDER
		SET		TOTAL_PURCHASE_ORDER_CLOSED=@PP_UPDATE_CLOSED
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		
		IF @@ROWCOUNT = 0
			BEGIN
				--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				SET @VP_MENSAJE='El [TOTAL CERRADO] no fue modificado. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
			END			
	END

	EXECUTE [dbo].[PG_UP_STATUS_PAGO]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
										-- ===========================
										@PP_K_HEADER_PURCHASE_ORDER
--	END
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'No es posible [Insertar] el [Pago_Detalle]: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
	-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / EL DETALLE DE LOS PAGOS REALIZADOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_STATUS_PAGO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_STATUS_PAGO]
GO
CREATE PROCEDURE [dbo].[PG_UP_STATUS_PAGO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		INT
AS
	DECLARE @VP_MENSAJE		NVARCHAR(MAX)
		
		-- SE ACTUALIZAN LOS TOTALES DE LA ORDEN DE COMPRA, LUEGO SE PROCEDE A REALIZAR LAS VALIDACIONES CORRESPONDIENTES.
		UPDATE	HEADER_PURCHASE_ORDER
		SET
				PREPAID_PURCHASE_ORDER=	ISNULL(												
										(	SELECT	SUM(PAGO_REALIZADO) 
											FROM	DETAILS_PAYMENT 
											WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
											AND		DETAILS_PAYMENT.L_BORRADO<>1		)
										,0)											
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='El PAGO no fue modificado. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END
			
		
		DECLARE @VP_K_STATUS_PAGO	INT
		DECLARE @VP_TOTAL_ORDEN		AS DECIMAL(19,2)
		DECLARE @VP_K_STATUS_PAID	INT

		--SE OBTIENE EL TOTAL PENDIENTE POR PAGAR.
		-- EL ESTATUS NOS SERVIRÁ CUANDO TIENE PAGOS PARCIALES.
		SELECT TOP (1)
			@VP_TOTAL_ORDEN=((CASE
				WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	TOTAL_PURCHASE_ORDER_CLOSED
				ELSE	TOTAL_PURCHASE_ORDER
			END)
			-	PREPAID_PURCHASE_ORDER),
			@VP_K_STATUS_PAID=K_STATUS_PAID_ORDER
		FROM	HEADER_PURCHASE_ORDER
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
		
		--IF	@VP_K_STATUS_PAID=30
		--BEGIN
		--	--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
		--	SET @VP_MENSAJE='Not is possible update, [PO] paid complete. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
		--	RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		--END
		
		
		-- EL TOTAL NO PUEDE SER MENOR A 0
		IF @VP_TOTAL_ORDEN<0
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
			SET @VP_MENSAJE='El [TOTAL < 0] no puede ser modificado. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END
		--SE ACTUALIZA EL ESTATUS DEL PAGO.
		ELSE IF @VP_TOTAL_ORDEN>0
		BEGIN			
			-- SE COMPARA EL TOTAL CON EL TOTAL NUEVAMENTE PARA ACTUALIZAR CORRECTAMENTE LOS REGISTROS DE LOS QUE SE DIO UN PAGO
			--	Y SE ELIMINO PARA PODER COLOCAR LA PO  DE NUEVA CUENTA EN EL ESTATUS "TO PAY"
			IF @VP_TOTAL_ORDEN = (
									SELECT TOP (1)
									(CASE
										WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	TOTAL_PURCHASE_ORDER_CLOSED
										ELSE	TOTAL_PURCHASE_ORDER
									END)
									FROM	HEADER_PURCHASE_ORDER
									WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
								)
			BEGIN
				SET @VP_K_STATUS_PAGO=10
			END
			ELSE
			BEGIN
				SET @VP_K_STATUS_PAGO=20	-- SI NO SE ES MENOR QUE 0 EL PAGO SE DEJA COMO ORDEN PAGADA PARCIAL.
			END

		END
		ELSE IF @VP_TOTAL_ORDEN=0
		BEGIN
			SET @VP_K_STATUS_PAGO=30	-- PAGADA COMPLETA
		END
			
		-- AQUI SE ACTUALIZA EL ESTATUS DE LA PO
		UPDATE	HEADER_PURCHASE_ORDER
		SET		K_STATUS_PAID_ORDER=	@VP_K_STATUS_PAGO		
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='El [PAGO] estatus no fue modificado. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END


		-- SE ACTUALIZAN EL TOTAL INGRESADO MANUALMENTE
		DECLARE @VP_TOTAL_PAGOS AS INT
		SET @VP_TOTAL_PAGOS=ISNULL((	SELECT	COUNT(K_DETAILS_PAYMENT) 
									FROM	DETAILS_PAYMENT 
									WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
									AND		L_BORRADO<>1),-1)

		IF @VP_TOTAL_PAGOS<=0
		BEGIN
		UPDATE	HEADER_PURCHASE_ORDER
		SET		TOTAL_PURCHASE_ORDER_CLOSED=0
		WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='El TOTAL CERRADO no fue modificado. [PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END
		END				
	-- /////////////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / EL DETALLE DE LOS PAGOS REALIZADOS
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_CANCELAR_PAGO]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_CANCELAR_PAGO]
GO
CREATE PROCEDURE [dbo].[PG_UP_CANCELAR_PAGO]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_K_PAYMENT					[INT],
	@PP_L_ELIMINAR_PAGO				[INT]			-- 0= NO / 1=SI
--	@PP_PAGO_REALIZADO				[DECIMAL](19,4)
AS
DECLARE @VP_MENSAJE		NVARCHAR(MAX)=''
	DECLARE	@VP_PAGO_IMPORTE				DECIMAL(19,4)
	DECLARE	@VP_PREPAID_PURCHASE_ORDER		DECIMAL(19,4)
	DECLARE @VP_NUEVO_SALDO					DECIMAL(19,4)
	DECLARE @VP_K_STATUS_PAID_ORDER			INT
BEGIN TRANSACTION 
BEGIN TRY

	DECLARE @VP_TIPO_MOVIMIENTO		VARCHAR(100)
	IF @PP_L_ELIMINAR_PAGO	=1
	BEGIN
		SET @VP_TIPO_MOVIMIENTO='ELIMINAR_PAGO'
	END
	ELSE
	BEGIN
		SET @VP_TIPO_MOVIMIENTO='CANCELAR_PAGO'
	END

	DECLARE	@VP_FECHA		DATETIME
	SELECT @VP_FECHA=GETDATE()

	EXECUTE	[dbo].[PG_IN_LOG_PAYMENT]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION
										-- ============================		
										,@PP_K_HEADER_PURCHASE_ORDER	,@PP_K_PAYMENT
										,''	--@PP_C_DETAILS_PAYMENT						
										-- ============================		
										-- CAMPOS ADICIONALES PARA PAYMENTS
										,0	--@PP_K_PAYMENT_METHOD						
										,@VP_FECHA	--@PP_F_DETAILS_PAYMENT						
										,''	--@PP_NO_IDENTICACION_PAGO					
										,''	--@PP_NO_FACTURA_PAGADA						
										,''	--@PP_NO_CUENTA_ORIGEN						
										,''	--@PP_NO_CUENTA_DESTINO					
										,0	--@PP_PAGO_IMPORTE							
										-- ============================
										,@VP_TIPO_MOVIMIENTO																


	-- /////////////////////////////////////////////////////////////////////
	-- OBTENEMOS EL PAGO_IMPORTE DEL PAGO A CANCELAR
	SELECT	@VP_PAGO_IMPORTE=PAGO_IMPORTE
	FROM	PAYMENT
	WHERE	K_PAYMENT=@PP_K_PAYMENT	
	
	IF	@PP_L_ELIMINAR_PAGO=1
	BEGIN
	DECLARE @VP_ES_BORRABLE			INT

		SELECT	@VP_ES_BORRABLE=L_BORRADO
		FROM	PAYMENT
		WHERE	K_PAYMENT=@PP_K_PAYMENT
		IF @@ROWCOUNT = 0
		BEGIN
			SET @VP_MENSAJE='No se obtuvo la condición L_BORRADO. [PAGO#'+CONVERT(VARCHAR(10),@PP_K_PAYMENT)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END

		IF @VP_ES_BORRABLE=1
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
			SET @VP_MENSAJE='No se puede borrar el pago, Notifiqué a sistemas. [PAGO#'+CONVERT(VARCHAR(10),@PP_K_PAYMENT)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END
		ELSE
		BEGIN
			DELETE	PAYMENT
			WHERE	K_PAYMENT=@PP_K_PAYMENT

			IF @@ROWCOUNT = 0
			BEGIN
				--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				SET @VP_MENSAJE='[PAGO] no existe. [PAGO#'+CONVERT(VARCHAR(10),@PP_K_PAYMENT)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
			END

			--==========================================================================			
			DELETE	DETAILS_PAYMENT
			WHERE	K_PAYMENT=@PP_K_PAYMENT

			IF @@ROWCOUNT = 0
			BEGIN
				--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				SET @VP_MENSAJE='[DETALLE_PAGO] no existe. [PAGO#'+CONVERT(VARCHAR(10),@PP_K_PAYMENT)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
			END
		END
	END
	ELSE
	BEGIN			
		--ACTUALIZAMOS EL ESTATUS DEL PAGO COLOCANDOLO INACTIVO PARA PODER UTLIZARLO EN OTRA ORDEN DE COMPRA.
		--Y PONEMOS LA CANTIDAD EN "POR APLICAR", PARA DISPONER DE ÉL EN OTRA ORDEN DE COMPRA.
		UPDATE	PAYMENT
		SET
			K_STATUS_PAYMENT	= 0
			,PAGO_APLICADO		= 0
			,PAGO_X_APLICAR		= @VP_PAGO_IMPORTE
			,L_BORRADO			= 1
		WHERE	K_PAYMENT=@PP_K_PAYMENT

		IF @@ROWCOUNT = 0
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
			SET @VP_MENSAJE='[PAGO] no fue modificado. [PAGO#'+CONVERT(VARCHAR(10),@PP_K_PAYMENT)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END

		--==========================================================================
		-- EL DETALLE DE PAGO LO COLOCAMOS COMO -999 PARA PODER LOCALIZARLO Y ASIGNARLO A OTRA PO.
		UPDATE	DETAILS_PAYMENT
		SET		K_HEADER_PURCHASE_ORDER	= -999,
				L_BORRADO				= 1,
				K_USUARIO_BAJA			= @PP_K_USUARIO_ACCION,
				F_BAJA					= GETDATE()						
		WHERE	K_PAYMENT=@PP_K_PAYMENT

		IF @@ROWCOUNT = 0
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
			SET @VP_MENSAJE='[Pago_detalle] no fue modificado. [PAGO#'+CONVERT(VARCHAR(10),@PP_K_PAYMENT)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END
	END

	-- SE MANDA LLAMAR EL UP_STATUS AQUI SUMA LOS DETALLES ASIGNADOS A LA PO
	-- COMO SE LE QUITA LA ASIGNACIÓN DE LA PO EN EL DETALLE LOS NUEVOS TOTALES 
	-- SERÁN OTROS, ESTOS SE ACTUALIZAN EN EL [PG_UP_STATUS_PAGO]
	EXECUTE [dbo].[PG_UP_STATUS_PAGO]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
										-- ===========================
										@PP_K_HEADER_PURCHASE_ORDER

-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'No es posible [Cancelar] el registro: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
-- //////////////////////////////////////////////////////////////
GO


-- //////////////////////////////////////////////////////////////
-- // STORED PROCEDURE ---> SELECT / ASIGNAR UN PAGO POR APLICAR
-- //								UNA NUEVA ORDEN DE COMPRA.
-- //////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PAGO_X_APLICAR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_UP_PAGO_X_APLICAR]
GO
--		EXECUTE [PG_UP_PAGO_X_APLICAR] 0,139,21 , 4 , 'PAGO4 565656565656565' , '132131321' , '565656565656565' , '56565656565656'
CREATE PROCEDURE [dbo].[PG_UP_PAGO_X_APLICAR]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_K_DETAILS_PAYMENT			[INT],
	-----==========================================
	@PP_C_DETAILS_PAYMENT			[VARCHAR](500),
	-----==========================================
	@PP_NO_CUENTA_DESTINO			[VARCHAR](100),	
	@PP_NO_IDENTICACION_PAGO		[VARCHAR](100),
	@PP_NO_FACTURA_PAGADA			[VARCHAR](100)
AS
DECLARE @VP_MENSAJE		NVARCHAR(MAX)=''
	DECLARE	@VP_PAGO_X_APLICAR				DECIMAL(19,4)
	DECLARE	@VP_PAGO_APLICADO				DECIMAL(19,4)
	DECLARE @VP_ESTATUS_PAYMENT				INT
	DECLARE @VP_K_PAYMENT					INT
	DECLARE @VP_K_PAYMENT_METHOD			INT
	DECLARE @VP_NO_CUENTA_ORIGEN			VARCHAR(100)
	DECLARE @VP_F_PAYMENT					DATETIME
BEGIN TRANSACTION 
BEGIN TRY
	-- /////////////////////////////////////////////////////////////////////
	-- OBTENEMOS LOS DATOS NECESARIOS PARA LA ACTUALIZACION DE LA TABLA
	--	Y EL ESTATUS QUE NOS INDICARÁ SI EL PAGO YA FUE DISPUESTO
	-- POR OTRA [PO]
	SELECT	@VP_PAGO_X_APLICAR		=PAGO_X_APLICAR		-- ES EL SALDO DISPONIBLE DEL PAGO.
			,@VP_PAGO_APLICADO		=PAGO_APLICADO		-- ES EL SALDO QUE SE HA UTILIZADO.
			,@VP_ESTATUS_PAYMENT	=K_STATUS_PAYMENT
			,@VP_K_PAYMENT			=DETAILS_PAYMENT.K_PAYMENT
			,@VP_K_PAYMENT_METHOD	=K_PAYMENT_METHOD
			,@VP_F_PAYMENT			=F_PAYMENT
			,@VP_NO_CUENTA_ORIGEN	=NO_CUENTA_ORIGEN
	FROM	PAYMENT
	INNER JOIN DETAILS_PAYMENT	ON DETAILS_PAYMENT.K_PAYMENT=PAYMENT.K_PAYMENT
	WHERE	K_DETAILS_PAYMENT=@PP_K_DETAILS_PAYMENT
				

		IF	@VP_ESTATUS_PAYMENT=1
		BEGIN
			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
			--SET @VP_MENSAJE='No es posible actualizar [PAGO], estatus [ACTIVO]. [PAGO#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
			SET @VP_MENSAJE='Estatus [ACTIVO] en el record. [PAGO#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
		END
		ELSE
		BEGIN
				IF @VP_MENSAJE=''
				BEGIN
						EXECUTE	[dbo].[PG_IN_LOG_PAYMENT]	@PP_K_SISTEMA_EXE	,@PP_K_USUARIO_ACCION
															-- ============================		
															,@PP_K_HEADER_PURCHASE_ORDER	,@VP_K_PAYMENT
															,@PP_C_DETAILS_PAYMENT						
															-- ============================		
															-- CAMPOS ADICIONALES PARA PAYMENTS
															,@VP_K_PAYMENT_METHOD						
															,@VP_F_PAYMENT	--@PP_F_DETAILS_PAYMENT
															,@PP_NO_IDENTICACION_PAGO					
															,@PP_NO_FACTURA_PAGADA						
															,''	--@PP_NO_CUENTA_ORIGEN						
															,@PP_NO_CUENTA_DESTINO					
															,@VP_PAGO_X_APLICAR	--@PP_PAGO_IMPORTE							
															-- ============================
															,'ACTUALIZAR_PAGO'	--@VP_TIPO_MOVIMIENTO
				END

			-- SE OBTIENE LA CANTIDAD A PAGAR DE LA ORDEN DE COMPRA
			DECLARE	@VP_SALDO_DE_LA_ORDEN	DECIMAL(19,4)
				SELECT	TOP (1)					
							@VP_SALDO_DE_LA_ORDEN=
							(CASE
								WHEN
									(SELECT	COUNT(K_HEADER_PURCHASE_ORDER)	
									FROM	DETAILS_PAYMENT	
									WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER)=0 AND	K_STATUS_PURCHASE_ORDER=14 THEN	0
								WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	TOTAL_PURCHASE_ORDER_CLOSED-PREPAID_PURCHASE_ORDER
								ELSE	TOTAL_PURCHASE_ORDER-PREPAID_PURCHASE_ORDER
							END)
				FROM		HEADER_PURCHASE_ORDER
				WHERE		HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER
								
			--	SE COMPARA LO DISPONIBLE EN LOS PAGOS CON LO QUE SE DEBE PAGAR.
			--	SI EL SALDO DISPONIBLE EN LOS PAGOS ES MENOR QUE EL TOTAL DE LA ORDEN
			IF	@VP_PAGO_X_APLICAR>@VP_SALDO_DE_LA_ORDEN
			BEGIN
			--==========================================================================
				--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
				SET @VP_MENSAJE='La cantidad por aplicar no debe ser mayor al pago restante. [PAGO#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
				RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
			--==========================================================================
			--==========================================================================
			END
			--==========================================================================
			ELSE
			BEGIN
				--==========================================================================
				--==========================================================================
				-- ACTUALIZAMOS LOS DETALLES DE PAGO
				UPDATE	DETAILS_PAYMENT
				SET		K_HEADER_PURCHASE_ORDER	= @PP_K_HEADER_PURCHASE_ORDER,
						--====================================================
						C_DETAILS_PAYMENT		= @PP_C_DETAILS_PAYMENT,	
						-----===================	-----=====================
						NO_IDENTICACION_PAGO	= @PP_NO_IDENTICACION_PAGO,
						NO_FACTURA_PAGADA		= @PP_NO_FACTURA_PAGADA,	
						--====================================================
						L_BORRADO				= 0,
						K_USUARIO_CAMBIO		= @PP_K_USUARIO_ACCION,
						F_CAMBIO				= GETDATE()
				WHERE	K_PAYMENT=@VP_K_PAYMENT
				AND		K_DETAILS_PAYMENT=@PP_K_DETAILS_PAYMENT
				
				IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='[Pago_detalle_UP] no fue modificado. [PAGO#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END
							
				----==========================================================================
				----==========================================================================
				--SE OBTIENEN LOS NUEVOS TOTALES
				UPDATE	PAYMENT
					SET
						K_STATUS_PAYMENT	= 1,				-- #1 ES ACTIVO, SIGNIFICA QUE YA SE UTILIZÓ EL PAGO.
						PAGO_APLICADO		= @VP_PAGO_X_APLICAR,
						PAGO_X_APLICAR		= @VP_PAGO_APLICADO
					WHERE	K_PAYMENT=@VP_K_PAYMENT

				IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='[PAGO_UP] no fue modificado. [PAGO#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END

			END

			-- SE MANDA LLAMAR EL UP_STATUS AQUI SUMA LOS DETALLES ASIGNADOS A LA PO
			-- COMO SE LE QUITA LA ASIGNACIÓN DE LA PO EN EL DETALLE LOS NUEVOS TOTALES 
			-- SERÁN OTROS, ESTOS SE ACTUALIZAN EN EL [PG_UP_STATUS_PAGO]
			EXECUTE [dbo].[PG_UP_STATUS_PAGO]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
												-- ===========================
												@PP_K_HEADER_PURCHASE_ORDER	
		END
		
-- /////////////////////////////////////////////////////////////////////
COMMIT TRANSACTION 
END TRY

BEGIN CATCH
	/* Ocurrió un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION
	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
END CATCH	
	-- /////////////////////////////////////////////////////////////////////	
	IF @VP_MENSAJE<>''
	BEGIN
		SET		@VP_MENSAJE = 'No es posible [ACTUALIZAR] el registro: ' + @VP_MENSAJE 
	END
	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
-- //////////////////////////////////////////////////////////////
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_IN_LOG_PAYMENT]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[PG_IN_LOG_PAYMENT]
GO
CREATE PROCEDURE [dbo].[PG_IN_LOG_PAYMENT]
	@PP_K_SISTEMA_EXE				INT,
	@PP_K_USUARIO_ACCION			INT,
	-- ===========================
	@PP_K_HEADER_PURCHASE_ORDER		[INT],
	@PP_K_PAYMENT					[INT],
	@PP_C_DETAILS_PAYMENT			[VARCHAR](500),
	-----=====================================================
	@PP_K_PAYMENT_METHOD			[INT],
	@PP_F_PAYMENT					[DATE],
	@PP_NO_IDENTICACION_PAGO		[VARCHAR](100),
	@PP_NO_FACTURA_PAGADA			[VARCHAR](100),
	@PP_NO_CUENTA_ORIGEN			[VARCHAR](100),
	@PP_NO_CUENTA_DESTINO			[VARCHAR](100),
	@PP_PAGO_IMPORTE				[DECIMAL](19,4),
	-- ============================
	@PP_TIPO_MOVIMIENTO				[VARCHAR](100)
	-----=====================================================
AS			
DECLARE @VP_MENSAJE						VARCHAR(500) = ''
	--============================================================================
	--======================================INSERTAR BITACORA DE PAGOS
	--============================================================================
	IF @PP_TIPO_MOVIMIENTO='CANCELAR_PAGO'	OR	@PP_TIPO_MOVIMIENTO='ELIMINAR_PAGO'
	BEGIN
		INSERT INTO LOG_PAYMENT
			(	[K_PAYMENT]			
				,[K_HEADER_PURCHASE_ORDER]		
				-- ============================
				-- CAMPOS ADICIONALES PARA PAYMENTS
				,[K_PAYMENT_METHOD]	
				,[F_DETAILS_PAYMENT]	
				,[NO_IDENTICACION_PAGO]
				,[NO_FACTURA_PAGADA]
				,[NO_CUENTA_DESTINO]	
				,[PAGO_IMPORTE]	
				,[C_DETAILS_PAYMENT]				
				,[TIPO_MOVIMIENTO]		
				-- ============================
				,[K_USUARIO_ALTA], [F_ALTA]	)
		--VALUES	
			SELECT	PAYMENT.K_PAYMENT
					,K_HEADER_PURCHASE_ORDER
					,K_PAYMENT_METHOD
					,F_DETAILS_PAYMENT
					,NO_IDENTICACION_PAGO
					,[NO_FACTURA_PAGADA]
					,[NO_CUENTA_DESTINO]	
					,[PAGO_IMPORTE]	
					,[C_DETAILS_PAYMENT]				
					,@PP_TIPO_MOVIMIENTO
				-- ============================
					,@PP_K_USUARIO_ACCION
					,GETDATE()
			FROM	PAYMENT
			INNER JOIN	DETAILS_PAYMENT ON DETAILS_PAYMENT.K_PAYMENT=PAYMENT.K_PAYMENT
			AND		PAYMENT.K_PAYMENT=@PP_K_PAYMENT

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='La Bitácora no fue registrada.[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END
		END
		ELSE
		BEGIN	
			INSERT INTO LOG_PAYMENT
			(	[K_PAYMENT]			
				,[K_HEADER_PURCHASE_ORDER]		
				-- ============================
				-- CAMPOS ADICIONALES PARA PAYMENTS
				,[K_PAYMENT_METHOD]	
				,[F_DETAILS_PAYMENT]	
				,[NO_IDENTICACION_PAGO]
				,[NO_FACTURA_PAGADA]
				,[NO_CUENTA_DESTINO]	
				,[PAGO_IMPORTE]	
				,[C_DETAILS_PAYMENT]				
				,[TIPO_MOVIMIENTO]		
				-- ============================
				,[K_USUARIO_ALTA], [F_ALTA]	)
		VALUES		
			(	@PP_K_PAYMENT	
				,@PP_K_HEADER_PURCHASE_ORDER
				-- ============================
				,@PP_K_PAYMENT_METHOD		
				,@PP_F_PAYMENT				
				,@PP_NO_IDENTICACION_PAGO	
				,@PP_NO_FACTURA_PAGADA		
				,@PP_NO_CUENTA_DESTINO		
				,@PP_PAGO_IMPORTE
				,@PP_C_DETAILS_PAYMENT
				,@PP_TIPO_MOVIMIENTO
				-- ============================
				,@PP_K_USUARIO_ACCION, GETDATE()  )

			IF @@ROWCOUNT = 0
				BEGIN
					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
					SET @VP_MENSAJE='La Bitácora no fue registrada.[PO#'+CONVERT(VARCHAR(10),@PP_K_HEADER_PURCHASE_ORDER)+']'
					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
				END
		END
	-- //////////////////////////////////////////////////////////////
GO




---- //////////////////////////////////////////////////////////////
---- // STORED PROCEDURE ---> SELECT / ASIGNAR UN PAGO POR APLICAR
---- //								UNA NUEVA ORDEN DE COMPRA.
---- //////////////////////////////////////////////////////////////
--IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_UP_PAGO_X_APLICAR]') AND type in (N'P', N'PC'))
--	DROP PROCEDURE [dbo].[PG_UP_PAGO_X_APLICAR]
--GO
----		EXECUTE [PG_UP_PAGO_X_APLICAR] 0,139,21 , 4 , 'PAGO4 565656565656565' , '132131321' , '565656565656565' , '56565656565656'
--CREATE PROCEDURE [dbo].[PG_UP_PAGO_X_APLICAR]
--	@PP_K_SISTEMA_EXE				INT,
--	@PP_K_USUARIO_ACCION			INT,
--	-- ===========================
--	@PP_K_HEADER_PURCHASE_ORDER		[INT],
--	@PP_K_DETAILS_PAYMENT			[INT],
--	-----==========================================
--	@PP_C_DETAILS_PAYMENT			[VARCHAR](500),
--	-----==========================================
--	@PP_NO_CUENTA_DESTINO			[VARCHAR](100),	
--	@PP_NO_IDENTICACION_PAGO		[VARCHAR](100),
--	@PP_NO_FACTURA_PAGADA			[VARCHAR](100)
----	@PP_PAGO_REALIZADO				[DECIMAL](19,4)
--AS
--DECLARE @VP_MENSAJE		NVARCHAR(MAX)=''
--	DECLARE	@VP_PAGO_X_APLICAR				DECIMAL(19,4)
--	DECLARE	@VP_PAGO_APLICADO				DECIMAL(19,4)
--	DECLARE @VP_ESTATUS_PAYMENT				INT
--	DECLARE @VP_K_PAYMENT					INT
--	DECLARE @VP_K_PAYMENT_METHOD			INT
--	DECLARE @VP_F_PAYMENT					DATETIME
--BEGIN TRANSACTION 
--BEGIN TRY
--	-- /////////////////////////////////////////////////////////////////////
--	-- OBTENEMOS LOS DATOS NECESARIOS PARA LA ACTUALIZACION DE LA TABLA
--	--	Y EL ESTATUS QUE NOS INDICARÁ SI EL PAGO YA FUE DISPUESTO
--	-- POR OTRA [PO]
--	SELECT	@VP_PAGO_X_APLICAR		=PAGO_X_APLICAR,	-- ES EL SALDO DISPONIBLE DEL PAGO.
--			@VP_PAGO_APLICADO		=PAGO_APLICADO,		-- ES EL SALDO QUE SE HA UTILIZADO.
--			@VP_ESTATUS_PAYMENT		=K_STATUS_PAYMENT,
--			@VP_K_PAYMENT			=PAYMENT.K_PAYMENT,
--			@VP_K_PAYMENT_METHOD	=K_PAYMENT_METHOD,
--			@VP_F_PAYMENT			=F_PAYMENT
--	FROM	PAYMENT
--	INNER JOIN DETAILS_PAYMENT	ON DETAILS_PAYMENT.K_PAYMENT=PAYMENT.K_PAYMENT
--	WHERE	K_DETAILS_PAYMENT=@PP_K_DETAILS_PAYMENT
		
		

--		IF	@VP_ESTATUS_PAYMENT=1
--		BEGIN
--			--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--			SET @VP_MENSAJE='Not is possible update [PAYMENT], status [ACTIVE]. [PAYMENT#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
--			RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--		END
--		ELSE
--		BEGIN
--			-- SE OBTIENE LA CANTIDAD A PAGAR DE LA ORDEN DE COMPRA
--			DECLARE	@VP_SALDO_DE_LA_ORDEN	DECIMAL(19,4)
--				SELECT	TOP (1)					
--							@VP_SALDO_DE_LA_ORDEN=
--							(CASE
--								WHEN
--									(SELECT	COUNT(K_HEADER_PURCHASE_ORDER)	
--									FROM	DETAILS_PAYMENT	
--									WHERE	K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER)=0 AND	K_STATUS_PURCHASE_ORDER=14 THEN	0
--								WHEN	TOTAL_PURCHASE_ORDER_CLOSED>0 THEN	TOTAL_PURCHASE_ORDER_CLOSED-PREPAID_PURCHASE_ORDER
--								ELSE	TOTAL_PURCHASE_ORDER-PREPAID_PURCHASE_ORDER
--							END)
--				FROM		HEADER_PURCHASE_ORDER
--				WHERE		HEADER_PURCHASE_ORDER.K_HEADER_PURCHASE_ORDER=@PP_K_HEADER_PURCHASE_ORDER



--			--	SE COMPARA LO DISPONIBLE EN LOS PAGOS CON LO QUE SE DEBE PAGAR.
--			--	SI EL SALDO DISPONIBLE EN LOS PAGOS ES MENOR QUE EL TOTAL DE LA ORDEN
--			IF	@VP_PAGO_X_APLICAR>@VP_SALDO_DE_LA_ORDEN
--			BEGIN
--			--==========================================================================
--			-- SE OBTIENEN LOS NUEVOS TOTALES A INDICAR EN LA TABLA
--			DECLARE @VP_NUEVO_SALDO_APLICADO	DECIMAL(19,4)
--			DECLARE @VP_NUEVO_SALDO_X_APLICAR	DECIMAL(19,4)
			
--			SET @VP_NUEVO_SALDO_APLICADO	= @VP_PAGO_APLICADO + @VP_SALDO_DE_LA_ORDEN
--			SET @VP_NUEVO_SALDO_X_APLICAR	= @VP_PAGO_X_APLICAR - @VP_SALDO_DE_LA_ORDEN
--			--==========================================================================

--				--==========================================================================
--				--==========================================================================
--				--==========================================================================
--				UPDATE	PAYMENT
--				SET
--					K_STATUS_PAYMENT	= 0,
--					PAGO_APLICADO		= @VP_NUEVO_SALDO_APLICADO,
--					PAGO_X_APLICAR		= @VP_NUEVO_SALDO_X_APLICAR
--				WHERE	K_PAYMENT=@VP_K_PAYMENT
--				IF @@ROWCOUNT = 0
--				BEGIN
--					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--					SET @VP_MENSAJE='Not is possible update [PAYMENT_NEW]. [PAYMENT#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
--					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--				END
--				--==========================================================================
--				--==========================================================================
--				--==========================================================================
--				-- SI QUEDA SALDO A FAVOR EN POR APLICAR, SE DEBE HACER UN UPDATE Y UN INSERT EN EL DETALLE PARA DIVIDIR LOS PAGOS.
--				-- Y OBTENER EL NUEVO SALDO A FAVOR.
--				IF @VP_NUEVO_SALDO_X_APLICAR > 0
--				BEGIN
--						--==========================================================================
--						--==========================================================================
--						--==========================================================================
--						-- ACTUALIZAMOS LOS DETALLES DE PAGO
--						UPDATE	DETAILS_PAYMENT
--						SET		K_HEADER_PURCHASE_ORDER= @PP_K_HEADER_PURCHASE_ORDER,
--								--====================================================
--								C_DETAILS_PAYMENT		= @PP_C_DETAILS_PAYMENT,	
--								-----===================	-----=====================
--								NO_IDENTICACION_PAGO	= @PP_NO_IDENTICACION_PAGO,
--								NO_FACTURA_PAGADA		= @PP_NO_FACTURA_PAGADA,	
--								--====================================================
--								L_BORRADO				= 0,
--								PAGO_REALIZADO			= @VP_SALDO_DE_LA_ORDEN,
--								K_USUARIO_CAMBIO		= @PP_K_USUARIO_ACCION,
--								F_CAMBIO				= GETDATE()
--						WHERE	K_PAYMENT=@VP_K_PAYMENT
--						AND		K_DETAILS_PAYMENT=@PP_K_DETAILS_PAYMENT

--						IF @@ROWCOUNT = 0
--						BEGIN
--							--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--							SET @VP_MENSAJE='Not is possible update [DETAIL_PAYMENT_NEW]. [PAYMENT#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
--							RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--						END
--						--==========================================================================
--						--==========================================================================
--						--==========================================================================
--						-- SE MANDA LLAMAR UN INSERT CON EL SALDO DISPONIBLE EN LOS PAGOS PARA UTILIZAR EN OTRA PO
--						INSERT INTO DETAILS_PAYMENT
--							(	[K_HEADER_PURCHASE_ORDER]		
--								,[K_PAYMENT]			
--								,[C_DETAILS_PAYMENT]				
--								-- ============================
--								-- CAMPOS ADICIONALES PARA PAYMENTS
--								,[K_PAYMENT_METHOD]	
--								,[F_DETAILS_PAYMENT]	
--								,[NO_IDENTICACION_PAGO]
--								,[NO_FACTURA_PAGADA]
--								,[NO_CUENTA_DESTINO]	
--								--,[PAGO_IMPORTE]		
--								,[PAGO_REALIZADO]	
--								--,[PAGO_RESTANTE]		
--								--,[TOTAL_ORDEN_COMPRA]
--								-- ============================
--								,[K_USUARIO_ALTA], [F_ALTA], [K_USUARIO_CAMBIO], [F_CAMBIO],
--								[L_BORRADO], [K_USUARIO_BAJA], [F_BAJA]  )
--						VALUES	
--							(	-999							-- @PP_K_HEADER_PURCHASE_ORDER
--								,@VP_K_PAYMENT	
--								,@PP_C_DETAILS_PAYMENT
--								-- ============================
--								,@VP_K_PAYMENT_METHOD		
--								,@VP_F_PAYMENT				
--								,''								-- [NO_IDENTICACION_PAGO]
--								,''								-- [NO_FACTURA_PAGADA]
--								,@PP_NO_CUENTA_DESTINO			-- [NO_CUENTA_DESTINO]	
--								,@VP_NUEVO_SALDO_X_APLICAR		-- @PP_PAGO_REALIZADO
--								-- ============================
--								,@PP_K_USUARIO_ACCION, GETDATE(), @PP_K_USUARIO_ACCION, GETDATE(),
--								1, NULL, NULL  )

--							IF @@ROWCOUNT = 0
--								BEGIN
--									--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--									SET @VP_MENSAJE='The DETAILS_PAYMENT was not inserted. [PAYMENT#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
--									RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--								END
--				--==========================================================================
--				END
--				--==========================================================================
--				--==========================================================================				
--			--==========================================================================
--			--==========================================================================
--			END
--			--==========================================================================
--			ELSE IF @VP_PAGO_X_APLICAR<=@VP_SALDO_DE_LA_ORDEN
--			BEGIN
--				--==========================================================================
--				--==========================================================================
--				-- ACTUALIZAMOS LOS DETALLES DE PAGO
--				UPDATE	DETAILS_PAYMENT
--				SET		K_HEADER_PURCHASE_ORDER	= @PP_K_HEADER_PURCHASE_ORDER,
--						--====================================================
--						C_DETAILS_PAYMENT		= @PP_C_DETAILS_PAYMENT,	
--						-----===================	-----=====================
--						NO_IDENTICACION_PAGO	= @PP_NO_IDENTICACION_PAGO,
--						NO_FACTURA_PAGADA		= @PP_NO_FACTURA_PAGADA,	
--						--====================================================
--						L_BORRADO				= 0,
--						K_USUARIO_CAMBIO		= @PP_K_USUARIO_ACCION,
--						F_CAMBIO				= GETDATE()
--				WHERE	K_PAYMENT=@VP_K_PAYMENT
--				AND		K_DETAILS_PAYMENT=@PP_K_DETAILS_PAYMENT
				
--				IF @@ROWCOUNT = 0
--				BEGIN
--					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--					SET @VP_MENSAJE='Not is possible update [DETAIL_PAYMENT_UP]. [PAYMENT#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
--					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--				END
							
--				----==========================================================================
--				----==========================================================================
--				--SE OBTIENEN LOS NUEVOS TOTALES
--				---- SE OBTIENEN LOS NUEVOS TOTALES A INDICAR EN LA TABLA
--				DECLARE @VP_NUEVO_PAGO_APLICADO		DECIMAL(19,4)
--				DECLARE @VP_NUEVO_PAGO_X_APLICAR	DECIMAL(19,4)
--				DECLARE @VP_NUEVO_ESTATUS			INT=0
				
--				SET @VP_NUEVO_PAGO_APLICADO		= (SELECT SUM(PAGO_REALIZADO) FROM DETAILS_PAYMENT WHERE	K_PAYMENT=@VP_K_PAYMENT)			
--				SET @VP_NUEVO_PAGO_X_APLICAR	= @VP_PAGO_X_APLICAR - @VP_NUEVO_PAGO_APLICADO

--				IF @VP_NUEVO_PAGO_X_APLICAR=0
--				BEGIN
--					SET @VP_NUEVO_ESTATUS=1
--				END

--				UPDATE	PAYMENT
--					SET
--						K_STATUS_PAYMENT	= @VP_NUEVO_ESTATUS,				-- #1 ES ACTIVO, SIGNIFICA QUE YA SE UTILIZÓ EL PAGO.
--						PAGO_APLICADO		= @VP_NUEVO_PAGO_APLICADO,
--						PAGO_X_APLICAR		= @VP_NUEVO_PAGO_X_APLICAR
--					WHERE	K_PAYMENT=@VP_K_PAYMENT

--				IF @@ROWCOUNT = 0
--				BEGIN
--					--RAISERROR (@VP_ERROR_1, 16, 1 ) --MENSAJE - Severity -State.
--					SET @VP_MENSAJE='Not is possible update [PAYMENT_UP]. [PAYMENT#'+CONVERT(VARCHAR(10),@VP_K_PAYMENT)+']'
--					RAISERROR (@VP_MENSAJE, 16, 1 ) --MENSAJE - Severity -State.
--				END

--			END

--			-- SE MANDA LLAMAR EL UP_STATUS AQUI SUMA LOS DETALLES ASIGNADOS A LA PO
--			-- COMO SE LE QUITA LA ASIGNACIÓN DE LA PO EN EL DETALLE LOS NUEVOS TOTALES 
--			-- SERÁN OTROS, ESTOS SE ACTUALIZAN EN EL [PG_UP_STATUS_PAGO]
--			EXECUTE [dbo].[PG_UP_STATUS_PAGO]	@PP_K_SISTEMA_EXE, @PP_K_USUARIO_ACCION,
--												-- ===========================
--												@PP_K_HEADER_PURCHASE_ORDER	
--		END
		
---- /////////////////////////////////////////////////////////////////////
--COMMIT TRANSACTION 
--END TRY

--BEGIN CATCH
--	/* Ocurrió un error, deshacemos los cambios*/ 
--	ROLLBACK TRANSACTION
--	DECLARE @VP_ERROR_TRANS NVARCHAR(4000);
--	SET @VP_ERROR_TRANS = ERROR_MESSAGE() 
--	SET @VP_MENSAJE = 'ERROR:// ' + @VP_ERROR_TRANS
--END CATCH	
--	-- /////////////////////////////////////////////////////////////////////	
--	IF @VP_MENSAJE<>''
--	BEGIN
--		SET		@VP_MENSAJE = 'Not is possible [Update] [PAYMENT]: ' + @VP_MENSAJE 
--	END
--	SELECT	@VP_MENSAJE AS MENSAJE, @PP_K_HEADER_PURCHASE_ORDER AS CLAVE
---- //////////////////////////////////////////////////////////////
--GO
-- //////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////