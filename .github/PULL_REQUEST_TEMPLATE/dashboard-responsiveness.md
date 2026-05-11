# PR — Dashboard Responsiveness & A11Y

## Summary
Breakpoints, table→card transforms, performance, and accessibility.

## Screens / Reports
- [ ] 360 / 768 / 1024 / 1440 px screenshots
- [ ] Lighthouse Mobile report (≥90)
- [ ] Short capture of keyboard navigation + focus rings

## Reviewer Checklist
- [ ] Breakpoints render correctly; **no horizontal scroll at 360px**
- [ ] Tables collapse to cards with key fields; sticky filters/drawers behave
- [ ] URL query state preserved across navigation
- [ ] Performance: p95 <100ms on filter/sort; virtualization confirmed
- [ ] Accessibility: visible focus order; ARIA for dynamic regions; contrast ≥ 4.5:1
