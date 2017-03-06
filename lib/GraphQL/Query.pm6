#use Grammar::Tracer;
unit grammar GraphQL::Query;

rule TOP               {<Definition>+}
rule SourceCharacter   {<[\x[0009] \x[000A] \x[000D] \x[0020]..\x[FFFF]]>}
rule UnicodeBOM        {\x[FEFF]}
rule WhiteSpace        {\h}
rule LineTerminator    {\v}
rule Comments          {'#' <!LineTerminator>+ <.LineTerminator>}
rule Comma             {','}
rule rule             {
    || <Punctuator>
    || <Name>
    || <IntValue>
    || <FloatValue>
    || <StringValue>
}
rule Ignored           {
    || <UnicodeBOM>
    || <WhiteSpace>
    || <LineTerminator>
    || <Comment>
    || <Comma>
}

rule Punctuator        {
    || '!'
    || '$'
    || '('
    || ')'
    || '.'
    || ':'
    || '='
    || '@'
    || '{'
    || '|'
    || '}'
    || '['
    || ']'
}
rule Name              {:i<+[_a..z]>\w*}
rule Definition        {
    || <OperationDefinition>
    || <FragmentDefinition>
}
rule OperationDefinition   {
    <OperationType>
    <Name>?
    <VariableDefinitions>?
    <Directives>?
    <SelectionSet>
    #<SelectionSet>
}
rule OperationType     { 'query' || 'mutation' }
rule SelectionSet      {'{' ~ '}' <Selection>*}
rule Selection         {<Field> <FragmentSpread>? <InlineFragment>?}
rule Field             {<Alias>? <Name> <Arguments>? <Directives>? <SelectionSet>?}
rule Arguments         { '(' ~ ')' <Argument>+}
rule Argument          {<Name> ':' <Value>}
rule Alias             {<Name> ':'}
rule FragmentSpread    {'...' <FragmentName> <Directives>?}
rule FragmentDefinition{'fragment' <FragmentName> <TypeCondition> <Directives>? <SelectionSet>}
rule FragmentName      { <Name> {? $<Name> ne "on"} }
rule TypeCondition     {<NamedType>}
rule InlineFragment    {'...' <TypeCondition>? <Directives>? <SelectionSet>}
rule Value             {
    || <Variable>
    || <IntValue>
    || <FloatValue>
    || <StringValue>
    || <BooleanValue>
    || <NullValue>
    || <EnumValue>
    || <ListValue>
    || <ObjectValue>
}
rule IntValue          {<[-+]>? [<[1 .. 9]> \d* || '0']}
rule FloatValue        {<IntValue> [['.' \d+] || ['.' \d+]? <[eE]> <[+-]>? \d+]}
rule BooleanValue      {'true' || 'false'}
rule StringValue       {'"' ~ '"' <StrChar>*}
token StrChar           {
    || <-["\\]>
    || \\u <[\da..f]> ** 4
    || \\ <["\\/bfnrt]>
}
rule NullValue         {'null'}
rule EnumValue         {<Name> {$<Name eq none(<true false null>)>}}
rule ListValue         {'[' ~ ']' <Value>*}
rule ObjectValue       {'{' ~ '}' <ObjectField>}
rule ObjectField       {<Name> ':' <Value>}
rule Variable          {'$' <Name>}
rule VariableDefinitions{'(' ~ ')' <VariableDefinition>+}
rule VariableDefinition{<Variable> ':' <Type> <DefaultValue>?}
rule DefaultValue      {'=' <Value>}
rule Type              {<NamedType> <ListType> <NonNullType>}
rule NamedType         {<Name>}
rule ListType          {'[' ~ ']' <Type>}
rule NonNullType       {[
    || <NamedType>
    || <ListType>
] '!'}
rule Directives        {<Directive>+}
rule Directive         {'@' <Name> <Arguments>?}

