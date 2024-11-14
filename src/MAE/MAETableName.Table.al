table 85070 MAETableName
{

    Caption = 'MAETableCaptionENU';
    DrillDownPageID = MAETableNameList;
    LookupPageID = MAETableNameList;

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
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; Comment; Boolean)
        {
            CalcFormula = Exist(MAETableNameCommentLine WHERE("Table Name" = CONST(MAETableName),
                                                               "MAETableName No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(8; "No. series"; Code[10])
        {
            Caption = 'No. series';
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
        MAETableNameCommentLine: Record MAETableNameCommentLine;
    begin
        MAETableNameCommentLine.Reset;
        MAETableNameCommentLine.SetRange("Table Name", MAETableNameCommentLine."Table Name"::MAETableName);
        MAETableNameCommentLine.SetRange("MAETableName No.", "No.");
        MAETableNameCommentLine.DeleteAll(false);
    end;

    trigger OnInsert()
    var
        MAETableName: Record MAETableName;
    begin
        if "No." = '' then begin
            MAETableNameSetup.Get;
            MAETableNameSetup.TestField("MAETableName No. Series");
            "No. Series" := MAETableNameSetup."MAETableName No. Series";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
            while MAETableName.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");
            Date := Today;
        end;
        "Created By User Id." := UserId;
    end;

    var
        MAETableNameSetup: Record MAETableNameSetup;
        NoSeries: Codeunit "No. Series";

    [Scope('Cloud')]
    procedure AssistEdit(OldMAETableName: Record MAETableName): Boolean
    var
        MAETableName: Record MAETableName;
    begin
        MAETableName := Rec;
        MAETableNameSetup.Get;
        MAETableNameSetup.TestField("MAETableName No. Series");
        if NoSeries.LookupRelatedNoSeries(MAETableNameSetup."MAETableName No. Series", OldMAETableName."No. Series", MAETableName."No. Series") then begin
            MAETableName."No." := NoSeries.GetNextNo(MAETableName."No. Series");
            Rec := MAETableName;
            exit(true);
        end;
    end;
}

