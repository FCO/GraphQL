#use Grammar::Tracer;
unit grammar GraphQL::Schema;

rule TOP                    {
    :my @*CUSTOM-TYPES;
    <definition>*
}
token new-type              {\w+                                            }
rule definition             {<schema-type>                                  }
rule type-block             {'{' ~ '}' <field>*                             }
rule field                  {<field-name> ':' <type>                        }
rule field-name             {<name>                                         }
token name                  {\w+                                            }
proto rule type             {*                                              }
rule type:sym<req-list>     {'[' ~ ']' <type> '!'                           }
rule type:sym<list>         {'[' ~ ']' <type>                               }
rule type:sym<required>     {<itype> '!'                                    }
rule type:sym<itype>        {<itype>                                        }
proto rule itype            {*                                              }
rule itype:sym<Int>         {<sym>                                          }
rule itype:sym<Float>       {<sym>                                          }
rule itype:sym<String>      {<sym>                                          }
rule itype:sym<Boolean>     {<sym>                                          }
rule itype:sym<ID>          {<sym>                                          }
rule itype:sym<custom>      {@*CUSTOM-TYPES                                 }
proto rule schema-type      {*                                              }
rule schema-type:sym<type>  {
    <sym>
    <new-type>
    <type-block>
    {@*CUSTOM-TYPES.push: $<new-type>}
}
rule schema-type:sym<enum>  {
    <sym>
    <new-type>
    '{' ~ '}' <name>* %% \s+
    {@*CUSTOM-TYPES.push: $<new-type>}
}
