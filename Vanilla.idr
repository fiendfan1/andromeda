module Vanilla where

open import Function
open import Data.Product
open import Data.String
open import Data.Float
open import Data.Nat
open import Data.Integer
open import Data.Maybe
open import Data.Bool
open import Data.List
open import Data.Sum

-------------------
-- Type Synonyms --
-------------------

Name : Set
Name = String

----------
-- Type --
----------

data Scalar : Set where
    void  : Scalar

    float : Scalar
    int   : Scalar
    uint  : Scalar
    bool  : Scalar

data Type : Set where
    ScalarTy    : Scalar          → Type

    Sampler     : ℕ               → Type
    SamplerCube :                   Type

    Vec         : Scalar → ℕ      → Type
    Mat         : Scalar → ℕ  → ℕ → Type
    Array       : Type   → ℕ      → Type

    _⇝_         : Type → Type     → Type

----------
-- Term --
----------

TypedVar : Set
TypedVar = Name × Type

mutual
  data Literal : Set where
      LitCode  : String → Type → Literal

      LitFlt   : Float         → Literal
      LitInt   : ℤ             → Literal
      LitUInt  : ℕ             → Literal
      LitBool  : Bool          → Literal

      PreUnOp  : Name → Type   → Literal
      PostUnOp : Name → Type   → Literal
      BinOp    : Name → Type   → Literal

      -- Translate to ternary "b ? t : f"
      If       : Term → Term → Term → Literal

  data Term : Set where
      Var : TypedVar        → Term
      Lit : Literal         → Term
      App : Term → Term     → Term
      Lam : TypedVar → Term → Term

Context : Set
Context = List (Name × Type)

------------
-- Typing --
------------

data TypeError : Set where
    ErrMsg : String -> TypeError
    IfTypeMismatch : Term -> Term -> TypeError

TypeCheck : Set -> Set
TypeCheck A = A ⊎ TypeError

mutual
  typeLit : Context → Literal → TypeCheck Type
  typeLit ctx (LitCode _ ty) = inj₁ ty
  typeLit ctx (LitFlt _) = inj₁ (ScalarTy float)
  typeLit ctx (LitInt _) = inj₁ (ScalarTy int)
  typeLit ctx (LitUInt _) = inj₁ (ScalarTy uint)
  typeLit ctx (LitBool _) = inj₁ (ScalarTy bool)
  typeLit ctx (PreUnOp _ ty) = inj₁ ty
  typeLit ctx (PostUnOp _ ty) = inj₁ ty
  typeLit ctx (BinOp _ ty) = inj₁ ty
  typeLit ctx (If x t e) = {! !}
{-
      let tyT = typeWith ctx t
      in if t == typeWith
-}

  typeWith : Context → Term → Type
  typeWith ctx (Var (name , ty)) = ty
  typeWith ctx (Lit x) = {!   !}
  typeWith ctx (App t t₁) = {!   !}
  typeWith ctx (Lam x t) = {!   !}