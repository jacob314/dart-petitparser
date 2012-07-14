// Copyright (c) 2012, Lukas Renggli <renggli@gmail.com>

/**
 * Lisp grammar definition.
 */
class LispGrammar extends CompositeParser {

  void initialize() {
    def('start', ref('atoms').end());

    def('atom',
      ref('list')
        .or(ref('string'))
        .or(ref('symbol'))
        .or(ref('number'))
        .or(ref('quote'))
        .or(ref('quasiquote'))
        .or(ref('unquote'))
        .or(ref('splice')));
    def('atoms',
      ref('cell')
        .or(ref('null')));
    def('cell', ref('atom').seq(ref('atoms')));
    def('null', epsilon());
    
    def('list',
      ref('list ()')
        .or(ref('list []'))
        .or(ref('list {}')));
    def('list ()',
      char('(').flatten()
        .seq(ref('atoms'))
        .seq(char(')').flatten()));
    def('list []',
      char('[').flatten()
        .seq(ref('atoms'))
        .seq(char(']').flatten()));
    def('list {}',
      char('{').flatten()
        .seq(ref('atoms'))
        .seq(char('}').flatten()));
    
    def('string',
      char('"')
        .seq(ref('character').star())
        .seq(char('"'))
        .flatten());
    def('character',
      ref('character escape')
        .or(ref('character raw')));
    def('character escape',
      char('\\').seq(any()));
    def('character raw',
      pattern('^"'));
    
    def('symbol',
      pattern('a-zA-Z0-9!#\$%&*/:<=>?@\\^_|~').plus().flatten());
    
    def('number', 
      char('-').optional()
        .seq(char('0').or(digit().plus()))
        .seq(char('.').seq(digit().plus()).optional())
        .seq(anyIn('eE').seq(anyIn('-+').optional()).seq(digit().plus()).optional())
        .flatten());
    
    def('quote', char('\'').flatten().seq(ref('atom')));
    def('quasiquote', char('`').flatten().seq(ref('atom')));
    def('unquote', char(',').flatten().seq(ref('atom')));
    def('splice', char('@').flatten().seq(ref('symbol')));
  }

}