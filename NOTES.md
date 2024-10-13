# Development notes
John Nagle
nagle@animats.com

Reviving Rend3 after its abandonment.

## 2024-10-12

Changes to WGPU have broken Rend3. The worst change is

https://github.com/gfx-rs/wgpu/pull/5884

which changes the lifetime of "RenderPass" and Encoder to 'static

which generates this problem:

https://users.rust-lang.org/t/unexpected-borrowed-data-escapes-outside-of-closure-for-generic/119501/4

RenderPass and Controller ownership is currently manipulated by unsafe code. 
That needs to be figured out. 

###Trouble spots:

* take_rpass
  
  https://github.com/BVE-Reborn/rend3/blob/d088a841b0469d07d5a7ff3f4d784e97b4a194d5/rend3/src/graph/encpass.rs#L74
  
        pub(super) enum RenderGraphEncoderOrPassInner<'a, 'pass> {
            Encoder(&'a mut CommandEncoder),
            RenderPass(&'a mut RenderPass<'pass>),
            #[default]
            None,
        }   
  
        pub struct RenderGraphEncoderOrPass<'a, 'pass>(pub(super) RenderGraphEncoderOrPassInner<'a, 'pass>);
        ...
        pub fn take_rpass(&mut self, _handle: DeclaredDependency<RenderPassHandle>) -> &'a mut RenderPass<'pass> {
        match mem::take(&mut self.0) {
        
  This in itself seems legit, i.e. safe. Except that it's taking a mutable reference, not the object itself.
  There can only be one such mutable reference. Where does this come from?
  
  Around here:
  
  https://github.com/BVE-Reborn/rend3/blob/d088a841b0469d07d5a7ff3f4d784e97b4a194d5/rend3/src/graph/graph.rs#L451
  
  where there is unsafe code to seemingly allow two mutable references to the same object to exist simultaneously.
  
      // SAFETY: There is no active renderpass to borrow this. This reference lasts for the duration of
      // the call to exec.
      None => RenderGraphEncoderOrPassInner::Encoder(unsafe { &mut *encoder_cell.get() }),
      
  Note that this is not an assertion that the code here is safe.
  It is an unchecked constraint on the rest of the program.
  
  Why is this not done with a RefCell and .borrow_mut?
  
  Other than the mess around RenderPass, there's not that much unsafe code in rend3.
  This might be fixable.
  
  Maybe if we pass around something that has a RefCell<RenderGraphEncoderOrPassInner>
  to everybody who needs that...
  
  
