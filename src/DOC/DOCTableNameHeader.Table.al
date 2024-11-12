table 85000 DOCTableNameHeader
{
    // DOC Documento cabecera y líneas
    // =================================
    // <DocumentName>
    // <PluralDocumentName>
    // <NombreDocumento>
    // <nombreDocumento>
    // <nombreDocumentoPlural>
    // DocumentName
    // 
    // Sustitución de caracteres extraños
    // ======================================
    // "á"= " "
    // "é" = "'"
    // "í" = "¡"
    // "ó" = "¢"
    // 'ú" = "£"
    // 
    // µ?Öàé
    // 
    // "Á" = "µ"
    // "É" = "?"
    // "Í" = "Ö"
    // "Ó" = "à"
    // "Ú" = "é"
    // 
    // "ñ" = "¤"
    // "Ñ" = "¥"
    // 
    // Â¢ = ¢
    // Â¡ = ¡

    Caption = 'DOCTableCaptionENU Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Created By User Id."; Code[20])
        {
            Caption = 'Created By User Id.';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; Comment; Boolean)
        {
            CalcFormula = Exist(DOCTableNameCommentLine WHERE("Table Name" = CONST(Header),
                                                               "Document No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(8; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description)
        {
        }
    }

    trigger OnDelete()
    var
        DocumentNameCommentLine: Record DOCTableNameCommentLine;
        DocumentNameLine: Record DOCTableNameLine;
    begin
        DocumentNameLine.Reset;
        DocumentNameLine.SetRange("Document No.", "No.");
        DocumentNameLine.DeleteAll(true);

        DocumentNameCommentLine.Reset;
        DocumentNameCommentLine.SetRange("Table Name", DocumentNameCommentLine."Table Name"::Header);
        DocumentNameCommentLine.SetRange("Document No.", "No.");
        DocumentNameCommentLine.DeleteAll(false);
    end;

    trigger OnInsert()
    var
        DOCTableNameHeader: Record DOCTableNameHeader;
    begin
        if "No." = '' then begin
            DOCTableNameSetup.Get;
            DOCTableNameSetup.TestField("DOCTableCaptionENU No. Series");

            "No. Series" := DOCTableNameSetup."DOCTableCaptionENU No. Series";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
            while DOCTableNameHeader.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    var
        DOCTableNameSetup: Record DOCTableNameSetup;
        NoSeries: Codeunit "No. Series";

    procedure AssistEdit(OldDOCTableNameHeader: Record DOCTableNameHeader): Boolean
    var
        DOCTableNameHeader: Record DOCTableNameHeader;
    begin
        OldDOCTableNameHeader := Rec;
        DOCTableNameSetup.Get();
        DOCTableNameSetup.TestField("DOCTableCaptionENU No. Series");
        if NoSeries.LookupRelatedNoSeries(DOCTableNameSetup."DOCTableCaptionENU No. Series", OldDOCTableNameHeader."No. Series", DOCTableNameHeader."No. Series") then begin
            DOCTableNameHeader."No." := NoSeries.GetNextNo(DOCTableNameHeader."No. Series");
            Rec := OldDOCTableNameHeader;
            exit(true);
        end;
    end;
}

