#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsServer.FillItemList(Object);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		DocumentsServer.FillSpecialOffersCache(Object, Form, "SalesInvoice");
	EndIf;
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	DocumentsServer.FillSpecialOffersCache(Object, Form, "SalesInvoice");
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

// @deprecated
//Procedure OnCreateAtServerMobile(Object, Form, Cancel, StandardProcessing) Export
//	If Form.Parameters.Key.IsEmpty() Then
//		Form.CurrentPartner = Object.Partner;
//		Form.CurrentAgreement = Object.Agreement;
//		Form.CurrentDate = Object.Date;
//
//		ObjectData = DocumentsClientServer.GetStructureFillStores();
//		FillPropertyValues(ObjectData, Object);
//		DocumentsClientServer.FillStores(ObjectData, Form);
//		DocumentsServer.FillItemList(Object);
//	EndIf;
//EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	DocumentsServer.FillSpecialOffersCache(Object, Form, "SalesInvoice");
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

Procedure BeforeWrite(Object, Form, Cancel, WriteMode, PostingMode) Export
	Return;
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

// @deprecated
//Function GetItemRowType(Item) Export
//	Return Item.ItemType.Type;
//EndFunction

// @deprecated
//Procedure StoreOnChange(TempStructure) Export
//	For Each Row In TempStructure.Object.ItemList Do
//		Row.Store = TempStructure.Store;
//	EndDo;
//EndProcedure

// @deprecated
//Function GetStoresArray(Val Object) Export
//	ReturnValue = New Array();
//	TableOfStore = Object.ItemList.Unload( , "Store");
//	TableOfStore.GroupBy("Store");
//	ReturnValue = TableOfStore.UnloadColumn("Store");
//	Return ReturnValue;
//EndFunction

// @deprecated
//Function GetActualStore(Object) Export
//	ReturnValue = Catalogs.Stores.EmptyRef();
//	If Object.ItemList.Count() = 1 Then
//		ReturnValue = Object.AgreementInfo.Store;
//	Else
//		RowCount = Object.ItemList.Count();
//		PreviousRow = Object.ItemList.Get(RowCount - 2);
//		ReturnValue = PreviousRow.Store;
//	EndIf;
//	Return ReturnValue;
//EndFunction

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion